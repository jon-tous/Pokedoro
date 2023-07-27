//
//  SettingsView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/24/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("timerLength") var timerLength = 25
    
    let timerLengths = [1, 10, 15, 20, 25, 30, 45, 50] // 1 min option is just for testing... TODO delete it
    
    var body: some View {
        Form {
            Section("Focus Sessions") {
                Picker("Timer Length", selection: $timerLength) {
                    ForEach(timerLengths, id: \.self) {
                        Text("\($0) min")
                    }
                }.pickerStyle(.menu)
                Group {
                    Text("Heads up, trainer!").bold() +
                    Text(" Changing timer length will reset any active focus sessions.")
                }.font(.callout)
            }
            .listRowSeparator(.hidden)
        }
        .tint(.red)
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
        
    }
}
