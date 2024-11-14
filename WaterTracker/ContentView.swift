//
//  StartView.swift
//  WaterTracker
//
//  Created by Fahim on 12/11/24.
//

import SwiftUI

struct StartView: View {
    @State private var buttonText = "Sign In."
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Water Tracker.")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    NavigationLink(destination: SecondView()) {
                        Text(buttonText)
                            .fontWeight(.bold)
                            .padding()
                            .background(colorScheme == .dark ? Color.black : Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(80)
                    }
                }
                .padding()
            }
        }
        
    }
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var digits: [String] = Array(repeating: "", count: 5)
    @FocusState private var focusIndex: Int?
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            VStack {
                Text ("Enter your invite.")
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .padding()
                    .fontWeight(.bold)
                
                HStack (spacing: 12) {
                    ForEach(0..<5, id: \.self) { index in
                        TextField("", text: $digits[index])
                            .keyboardType(.numberPad)
                            .ignoresSafeArea(.keyboard)
                            .multilineTextAlignment(.center)
                            .padding(20)
                            .font(.title2)
                            .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.2))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .fontWeight(.bold)
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                            .focused($focusIndex, equals: index)
                            .onChange(of: digits[index]) { oldValue, newValue in
                                handleInputChange(newValue: newValue, index: index)
                            }
                    }
                    
                }
                if digits.allSatisfy({ !$0.isEmpty }) {
                    Text("Entered digits: \(digits.joined())")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    }
                    
            }
            .padding(.bottom, 200)
        }
        .onAppear {
            focusIndex = 0
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .fontWeight(.bold)
                }
            }
        })
        
    }
    
    /*func handleInputChange(newValue: String, index: Int) {
        // Ensure only a single character per field
        if newValue.count > 1 {
            digits[index] = String(newValue.prefix(1))
        }

        // Move focus to the next field if a character is entered and we are not at the last field
        if !newValue.isEmpty && index < 4 {
            focusIndex = index + 1
        }
        
        // Move focus back if character is deleted
        if newValue.isEmpty && index > 0 {
            focusIndex = index - 1
        }

        // Disable focus if all fields are filled
        if digits.allSatisfy({ !$0.isEmpty }) {
            focusIndex = nil
        }
    }*/
    
    func handleInputChange(newValue: String, index: Int) {
        // Ensure only a single character per field
        if newValue.count > 1 {
            digits[index] = String(newValue.prefix(1))
        }

        // Move focus to the next field if a character is entered and we are not at the last field
        if !newValue.isEmpty && index < 4 {
            focusIndex = index + 1
        }

        // **New Backspace Handling**
        // If the field is empty, indicating a backspace, move focus to the previous field
        else if newValue.isEmpty && index > 0 {
            digits[index] = ""  // Clear current field on backspace
            focusIndex = index - 1
        }

        // Disable focus if all fields are filled
        if digits.allSatisfy({ !$0.isEmpty }) {
            focusIndex = nil
        }
    }
    
}

#Preview {
    StartView()
}
