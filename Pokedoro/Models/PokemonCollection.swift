//
//  PokemonCollection.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/27/23.
//

import Foundation
import PokemonAPI

class PokemonCollection: ObservableObject {
    @Published var ownedPokemon = [PKMPokemon]()
    
//    @Published var generationLimit = Generation.LastIDInGeneration.gen1 // Refactor all references to Generation...gen1 to use the user's PokemonCollection
    
    var allNames: [String] {
        ownedPokemon.compactMap { $0.name }
    }
}
