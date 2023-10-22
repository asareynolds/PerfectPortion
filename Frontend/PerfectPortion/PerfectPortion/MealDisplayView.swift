//
//  MealDisplayView.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/22/23.
//

import SwiftUI

struct MealDisplayView: View {
    let meal: Meal
    
    var body: some View {
        ScrollView {
            Image(uiImage: UIImage(data: meal.imageData).unsafelyUnwrapped)
                .resizable()
                .scaledToFit()
                .frame(width: 80)
            
            ForEach(meal.foods, id: \.id) { food in
                Text("Name: \(food.name)")
                Text("Calories: \(food.calories)")
                Text("Proteins: \(food.proteins)")
                Text("Carbs: \(food.carbs)")
                Text("Fat: \(food.fat)")
            }
        }
    }
}

#Preview {
    MealDisplayView(meal: Meal(id: "", imageData: (UIImage(systemName: "carrot")?.pngData().unsafelyUnwrapped).unsafelyUnwrapped, timestamp: .now, foods: [Food(id: 0, name: "Carrot", calories: 0, proteins: 0, carbs: 0, fat: 0)]))
}
