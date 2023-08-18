//
//  PKMPokemon+.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/18/23.
//

import Foundation
import PokemonAPI

extension PKMPokemon: Identifiable { }

extension PKMPokemon: Equatable {
    public static func ==(lhs: PKMPokemon, rhs: PKMPokemon) -> Bool {
        lhs.id == rhs.id
    }
}
