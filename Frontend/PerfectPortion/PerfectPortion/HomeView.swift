//
//  ContentView.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/21/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Meal.timestamp, order: .reverse) private var meals: [Meal]

    var body: some View {
        NavigationStack {
            if meals.isEmpty {
                ContentUnavailableView("No Meals", systemImage: "takeoutbag.and.cup.and.straw", description: Text("Go add a meal"))
            }
            else {
                List {
                    ForEach(meals) { item in
                        NavigationLink {
                            MealDisplayView(meal: item)
                        } label: {
                            MealLabelView(meal: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }

        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(meals[index])
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Meal.self, inMemory: true)
}
