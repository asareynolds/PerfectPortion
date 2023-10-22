//
//  SettingsView.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/22/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Text("Perfect Portion")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("Perfect Portion is an app that automatically detects what food is present in a picture of a meal, listing key nutritional information and enabling users to make more informed choices about what they eat. We were inspired by our experiences of tediously entering information about our food. We wanted to create a solution that would be simple and accessible. Using a simple, intuitive UI system enables a wide range of people to track their food intake with minimal effort.")
                .padding()
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier.unsafelyUnwrapped)
                }) {
                    Text("Reset Preferences")
                        .foregroundStyle(.red)
                }
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}


#Preview {
    SettingsView()
}
