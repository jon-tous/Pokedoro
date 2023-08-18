//
//  PokemonDetailView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/18/23.
//

import SwiftUI
import PokemonAPI

struct PokemonDetailView: View {
    @EnvironmentObject var collection: PokemonCollection
    
    let pokemon: PKMPokemon
    
    var body: some View {
        VStack {
            PokemonImageView(id: pokemon.id ?? 0, types: PokemonType.getTypeStrings(from: pokemon.types ?? []),
//                             silhouette: !collection.ownedPokemon.contains(pokemon))
                             silhouette: false) // for debugging
                .padding()
            PokemonTitleView(pokemon: pokemon)
        }
    }
}
