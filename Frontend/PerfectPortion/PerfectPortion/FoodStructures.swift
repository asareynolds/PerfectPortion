//
//  FoodStructures.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/21/23.
//

import Foundation

struct ImageUploadResponse: Decodable {
    let result: String
    let imageId: String
}

struct Nutrient: Decodable {
    let quantity: Double
    let unit: String
}

struct FoodInfo: Decodable {
    let calories: Double
    let protein: Nutrient
    let carb: Nutrient
    let fat: Nutrient
}

struct FoodDetails: Decodable {
    let foodName: String
    let foodID: Int
    let info: FoodInfo
}
