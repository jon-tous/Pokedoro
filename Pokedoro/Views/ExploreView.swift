//
//  ExploreView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/21/23.
//

import SwiftUI

struct ExploreView: View {
    @AppStorage("timerLength") var timerLength = 25
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                Spacer()
                Group {
                    Text("Focus for ") +
                    Text("\(timerLength) \(timerLength == 1 ? "minute" : "minutes")").bold() +
                    Text(" to catch a new Pokémon!")
                }
                    .font(.title).fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                TimerView()
                Spacer()
                Spacer()
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
