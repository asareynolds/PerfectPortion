//
//  PerfectPortionApp.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/21/23.
//

import SwiftUI
import SwiftData

@main
struct PerfectPortionApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Meal.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .modelContainer(sharedModelContainer)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                AddMealView()
                    .modelContainer(sharedModelContainer)
                    .tabItem {
                        Label("Add", systemImage: "camera")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
