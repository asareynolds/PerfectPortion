//
//  MealLabelView.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/22/23.
//

import SwiftUI

struct MealLabelView: View {
    let meal: Meal
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: meal.imageData).unsafelyUnwrapped)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            Divider()
            
            HStack {
                Text("\(meal.totalCalories) Calories")
                Text("\(meal.totalCarbs) Carbs")
                Text("\(meal.totalProteins) Proteins")
                Text("\(meal.totalFat) Fat")
            }
        }
    }
}

#Preview {
    MealLabelView(meal: Meal(id: "", imageData: (UIImage(systemName: "carrot")?.pngData().unsafelyUnwrapped).unsafelyUnwrapped, timestamp: .now, foods: [Food(id: 0, name: "Carrot", calories: 0, proteins: 0, carbs: 0, fat: 0)]))
}
