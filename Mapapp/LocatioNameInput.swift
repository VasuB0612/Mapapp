//
//  LocatioNameInput.swift
//  Mapapp
//
//  Created by Vasu Bhatnagar on 7.11.2024.
//

import SwiftUI

struct LocationNameInputView: View {
    // A binding to the location name, so changes are reflected in ContentView
    @Binding var locationName: String
        var onSave: () -> Void // A closure to be executed when saving the location
        
        var body: some View {
            VStack {
                // TextField for entering the location name
                TextField("Enter name for location", text: $locationName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Styling for the text field
                
                // Save button to trigger the location save action
                Button("Save Location") {
                    onSave() // Trigger the save action passed from ContentView
                }
                .padding()
            }
            .padding()
        }
}
