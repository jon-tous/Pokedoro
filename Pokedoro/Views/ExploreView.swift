//
//  ExploreView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/21/23.
//

import SwiftUI

struct ExploreView: View {
    @AppStorage("timerLength") var timerLength = 25
    
    @State var timerRunning = false
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                Spacer()
                message
                    .font(.title).fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                TimerView(timerRunning: $timerRunning)
                Spacer()
                Spacer()
            }
        }
    }
    
    var timerNotRunnningMessage: some View {
        Text("Focus for ") +
        Text("\(timerLength) \(timerLength == 1 ? "minute" : "minutes")").bold() +
        Text(" to catch a new Pokémon!")
    }
    
    var timerRunningMessage: some View {
        Text("Searching for wild Pokémon.\nStay focused, trainer!")
    }
    
    @ViewBuilder var message: some View {
        if timerRunning { timerRunningMessage } else { timerNotRunnningMessage }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
