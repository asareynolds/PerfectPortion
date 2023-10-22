//
//  OnboardingView.swift
//  PerfectPortion
//
//  Created by Ryan Nair on 10/22/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var hasOnboarded: Bool
    @AppStorage("height") private var height: String = ""
    @AppStorage("weight") private var weight: String = ""
    @AppStorage("age") private var age: String = ""
    @AppStorage("allergies") private var allergies: String = ""
    @AppStorage("gender") private var gender: String = ""
    
    var body: some View {
        ScrollView {
            Spacer()
            Text("Welcome to Perfect Portion!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Height")
                    TextField("Enter your Height", text: $height)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Weight")
                    TextField("Enter your Weight", text: $weight)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Age")
                    TextField("Enter your Age", text: $age)
                        .textFieldStyle(.roundedBorder)
                }
                
                Group {
                    Text("Gender")
                    Picker("Select your gender", selection: $gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Allergies/Restrictions")
                    TextField("Enter allergies or restrictions", text: $allergies)
                        .textFieldStyle(.roundedBorder)
                }
            }.padding()
            
            Spacer()
            
            Button(action: { hasOnboarded = true }, label: {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(height.isEmpty || weight.isEmpty)
            })
            .padding()
        }
        .sensoryFeedback(.success, trigger: hasOnboarded)
    }
}

#Preview {
    OnboardingView(hasOnboarded: .constant(false))
}
