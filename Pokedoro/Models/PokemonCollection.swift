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
    
    var allNames: [String] {
        ownedPokemon.compactMap { $0.name }
    }
}
