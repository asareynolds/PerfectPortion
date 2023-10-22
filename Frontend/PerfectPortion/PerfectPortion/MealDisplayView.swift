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
                .frame(width: 400)
            
            Text(meal.recommendation)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(uiColor: .systemGroupedBackground))
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                )
                .padding()
            
            ForEach(meal.foods, id: \.id) { food in
                Text(food.name)
                    .fontWeight(.heavy)
                Text("Calories: \(food.calories)")
                Text("Proteins: \(food.proteins)")
                Text("Carbs: \(food.carbs)")
                Text("Fat: \(food.fat)")
                
                Divider()
            }
        }
    }
}

#Preview {
    MealDisplayView(meal: Meal(id: "", imageData: (UIImage(systemName: "carrot")?.pngData().unsafelyUnwrapped).unsafelyUnwrapped, timestamp: .now, foods: [Food(id: 0, name: "Carrot", calories: 0, proteins: 0, carbs: 0, fat: 0)], recommendation: "Generative AI Response"))
}
