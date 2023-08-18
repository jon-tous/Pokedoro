//
//  PokemonEvolutions.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 8/18/23.
//

import Foundation
import PokemonAPI

class PokemonEvolutions: ObservableObject {
    @Published var pokemonEvolutions = [String: Set<String>]() // ["eevee" : ["vaporeon", "jolteon", "flareon"...]] // ["bulbasaur" : ["ivysaur"]]
}
