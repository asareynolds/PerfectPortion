//
//  ImageViewModel.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/21/23.
//
// Copyright © 2023 Apple Inc.
/*
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//Abstract:
//A class that responds to Photos picker events.*/


import SwiftUI
import PhotosUI

/// A view model that integrates a Photos picker.
@Observable final class ImageViewModel {
    /// A class that manages an image that a person selects in the Photos picker.
    @Observable final class ImageAttachment: Identifiable {
        
        /// Statuses that indicate the app's progress in loading a selected photo.
        enum Status {
        
            /// A status indicating that the app has requested a photo.
            case loading
            
            /// A status indicating that the app has loaded a photo.
            case finished(UIImage)
            
            /// A status indicating that the photo has failed to load.
            case failed(Error)
            
            /// Determines whether the photo has failed to load.
            var isFailed: Bool {
                return switch self {
                case .failed: true
                default: false
                }
            }
        }
        
        /// An error that indicates why a photo has failed to load.
        enum LoadingError: Error {
            case contentTypeNotSupported
        }
        
        /// A reference to a selected photo in the picker.
        @ObservationIgnored private let pickerItem: PhotosPickerItem
        
        /// A load progress for the photo.
        var imageStatus: Status?
        
        /// An identifier for the photo.
        nonisolated var id: String {
            pickerItem.identifier
        }
        
        /// Creates an image attachment for the given picker item.
        init(_ pickerItem: PhotosPickerItem) {
            self.pickerItem = pickerItem
        }
        
        /// Creates an image attachment for the given picker item.
        init(_ withImage: UIImage) {
            imageStatus = .finished(withImage)
            pickerItem = .init(itemIdentifier: "")
        }
        
        /// Loads the photo that the picker item features.
        @MainActor func loadImage() async {
            guard imageStatus == nil || imageStatus?.isFailed == true else {
                return
            }
            imageStatus = .loading
            do {
                if let data = try await pickerItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    imageStatus = .finished(uiImage)
                } else {
                    throw LoadingError.contentTypeNotSupported
                }
            } catch {
                imageStatus = .failed(error)
            }
        }
    }

    /// An array of items for the picker's selected photos.
    ///
    /// On set, this method updates the image attachments for the current selection.
    var selection = [PhotosPickerItem]() {
        didSet {
            // Update the attachments according to the current picker selection.
            let newAttachments = selection.map { item in
                // Create a new attachment.
                ImageAttachment(item)
            }
            // To support asynchronous access, assign new arrays to the instance properties rather than updating the existing arrays.
            attachments = newAttachments
        }
    }
    
    /// An array of image attachments for the picker's selected photos.
    var attachments = [ImageAttachment]()
    
    private func createBody(with data: Data, boundary: String) -> Data {
        var body = Data()
        
        // Helper function to append strings to the body
        func appendString(_ string: String) {
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }
        
        // Append the data to the body
        appendString("--\(boundary)\r\n")
        appendString("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(data)
        appendString("\r\n")
        appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    private(set) var uploadingString: String = ""
    private(set) var uploadingValue: Float = 0
    
    func uploadImage() async throws -> Meal? {
        guard case .finished(let image) = self.attachments.first?.imageStatus, let imageData = image.jpegData(compressionQuality: 0.15) else {
            uploadingString = "Failed to get the image to upload!"
            return nil
        }
    
        uploadingString = "Proccesing your image"
        uploadingValue = 0.2
        
        // Create the request
        let url = URL(string: "https://api.perfectportion.tech/post/image")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    
        // Generate a boundary string using a unique per-app string
        let boundary = UUID().uuidString
    
        // Set the content type to multipart/form-data with the boundary
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
        // Create the multipart/form-data body
        let body = createBody(with: imageData, boundary: boundary)
    
        let data = try await URLSession.shared.upload(for: request, from: body).0
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(ImageUploadResponse.self, from: data)
    
        let imageID = decodedResponse.imageId
        
        uploadingString = "Getting the nutrient information"
        uploadingValue = 0.6
    
        let foodDetails = try await URLSession.shared.data(from:  URL(string: "https://api.perfectportion.tech/get/nutrients?imageID=\(imageID)").unsafelyUnwrapped).0
    
        let foodItems = try decoder.decode([Int: FoodDetails].self, from: foodDetails)
        var foodsToAdd: [Food] = []
        
        for (id , details) in foodItems {
            let foodInfo = details.info
            let foodToAdd = Food(id: id, name: details.foodName.capitalized, calories: Int(foodInfo.calories), proteins: Int(foodInfo.protein.quantity), carbs: Int(foodInfo.carb.quantity), fat: Int(foodInfo.fat.quantity))
            foodsToAdd.append(foodToAdd)
        }
        
        let defaults = UserDefaults.standard
        let height = defaults.string(forKey: "height") ?? "70"
        let weight = defaults.string(forKey: "weight") ?? "150"
        let age = defaults.string(forKey: "age") ?? "20"
        let gender = defaults.string(forKey: "gender") ?? "male"
        let allergies = defaults.string(forKey: "allergies") ?? ""
        
        uploadingString = "Getting Generative API response"
        uploadingValue = 0.80
        
        let generationAPI = URL(string:"https://api.perfectportion.tech/get/recommendation?imageID=\(imageID)&weight=\(weight)&height=\(height)&age=\(age)&gender=\(gender)&allergies=\(allergies)").unsafelyUnwrapped
        
        let generatedResponse = try await URLSession.shared.data(from: generationAPI).0
        uploadingValue = 0.99
        
        let responseString = String(data: generatedResponse, encoding: .utf8) ?? "No Generative AI Response"
        
        let meal = Meal(id: imageID, imageData: imageData, timestamp: .now, foods: foodsToAdd, recommendation: responseString)
        return meal
    }
}

/// A extension that handles the situation in which a picker item lacks a photo library.
private extension PhotosPickerItem {
    var identifier: String {
        guard let identifier = itemIdentifier else {
            fatalError("The photos picker lacks a photo library.")
        }
        return identifier
    }
}
