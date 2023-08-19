//
//  PKMPokemonType+.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 8/18/23.
//

import Foundation
import PokemonAPI

extension PKMPokemonType: Hashable {
    public static func == (lhs: PKMPokemonType, rhs: PKMPokemonType) -> Bool {
        lhs.type?.name == rhs.type?.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type?.name)
    }
}
