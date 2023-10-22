//
//  Item.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/21/23.
//

import Foundation
import SwiftData

struct Food: Codable {
    let id: Int
    let name: String
    let calories: Int
    let proteins: Int
    let carbs: Int
    let fat: Int
}

@Model
final class Meal {
    @Attribute(.unique) var id: String
    @Attribute(.externalStorage) var imageData: Data
    
    var foods: [Food]
    let timestamp: Date
    let totalCalories: Int
    let totalProteins: Int
    let totalCarbs: Int
    let totalFat: Int
    let recommendation: String
    
    init(id: String, imageData: Data, timestamp: Date, foods: [Food], recommendation: String) {
        self.id = id
        self.imageData = imageData
        self.timestamp = timestamp
        self.foods = foods
        
        let total = foods.reduce((calories: 0, proteins: 0, carbs: 0, fat: 0)) { (acc, food) in
            (calories: acc.calories + food.calories,
             proteins: acc.proteins + food.proteins,
             carbs: acc.carbs + food.carbs,
             fat: acc.fat + food.fat)
        }
                
        self.totalCalories = total.calories
        self.totalProteins = total.proteins
        self.totalCarbs = total.carbs
        self.totalFat = total.fat
        self.recommendation = recommendation
    }
}
