//
//  TrainingView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 8/10/23.
//

import SwiftUI

struct TrainingView: View {
    var body: some View {
        ZStack {
            BackgroundGradient()
            Text("Choose a Pokémon with an evolution available to train!")
        }
        .task {
            populateTrainablePokemon()
        }
    }
    
    func populateTrainablePokemon() {
        
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView()
    }
}
