//
//  AddMeal.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/21/23.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct ImageDisplay: View {
    
    /// A view model for the list.
    var viewModel: ImageViewModel
    
    /// A container view for the list.
    var body: some View {
        // Display a stub image if the Photos picker lacks a selection.
        Spacer()
        if let imageAttachment = viewModel.attachments.first {
            ImageAttachmentView(imageAttachment: imageAttachment)
        }
        else {
            Image(systemName: "text.below.photo")
                .font(.system(size: 150))
                .opacity(0.2)
           
        }
        Spacer()
    }
}

/// A row item that displays a photo and a description.
struct ImageAttachmentView: View {
    
    /// An image that a person selects in the Photos picker.
    @Bindable var imageAttachment: ImageViewModel.ImageAttachment
    
    /// A container view for the row.
    var body: some View {
        HStack {
            
            // Add space after the description.
            Spacer()
            
            // Display the image that the text describes.
            switch imageAttachment.imageStatus {
            case .finished(let image):
                Image(uiImage:image).resizable().aspectRatio(contentMode: .fit)
            case .failed:
                Image(systemName: "exclamationmark.triangle.fill")
            case .none:
                ProgressView()
                    .task {
                        await imageAttachment.loadImage()
                    }
            case .some(.loading):
                ProgressView()
            }
            
            Spacer()
        }.task {
            // Asynchronously display the photo.
            await imageAttachment.loadImage()
        }
    }
}

struct AddMealView: View {
    @Environment(\.modelContext) private var modelContext
    /// A view model that provides the Photos picker with a selection.
    @State private var viewModel = ImageViewModel()
    @State private var capturedImage: UIImage?
    @State private var cameraTapped: Bool = false
    @State private var isLoading: Bool = false
      
    /// A body property for the app's UI.
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView("Uploading your image")
            }
            else if cameraTapped {
                CameraView(capturedImage: $capturedImage)
                    .onChange(of: capturedImage) { oldValue, newValue in
                        if oldValue != nil {
                            viewModel.attachments.removeLast()
                        }
                        if let newValue {
                            viewModel.attachments.append(ImageViewModel.ImageAttachment(newValue))
                        }
                        cameraTapped = false
                    }
            }
            else {
                VStack {
                    // Define a list for photos and descriptions.
                    Button{
                        cameraTapped = true
                    } label: {
                        ZStack(alignment: .bottomTrailing){
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Take").font(.caption).fontWeight(.light)
                                    Text("Picture").font(.title2).bold()
                                }
                                Spacer()
                            }
                            .padding(30)
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .rotationEffect(Angle(degrees: -20))
                                .offset(x: -10,y: -10)
                                .opacity(0.8)
                            
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: .init(colors: [.black, .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(12)
                    }
                    .padding()
                    
                    ImageDisplay(viewModel: viewModel)
                    
                    Button("Continue", systemImage: "arrow.right") {
                        Task {
                            isLoading = true
                            
                            let meal = try await viewModel.uploadImage()
                            if let meal {
                                modelContext.insert(meal)
                            }
                            isLoading = false
                        }
                        
                    }
                    .disabled(viewModel.attachments.isEmpty)
                    
                    // Define the app's Photos picker.
                    PhotosPicker("Select a photo", selection: $viewModel.selection, maxSelectionCount: 1, selectionBehavior: .continuous, matching: .images, photoLibrary: .shared())
                    // Configure a half-height Photos picker.
                        .photosPickerStyle(.inline)
                    
                    // Disable the cancel button for an inline use case.
                        .photosPickerDisabledCapabilities(.selectionActions)
                    // Hide padding around all edges in the picker UI.
                        .photosPickerAccessoryVisibility(.hidden, edges: .all)
                        .frame(height: 250)
                }
            }
        }
        .navigationTitle("Add Image")
    }
          
}

#Preview {
    AddMealView()
}
