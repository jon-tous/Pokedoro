//
//  PokemonDetailView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/18/23.
//

import SwiftUI
import PokemonAPI

struct PokemonDetailView: View {
    let pokemon: PKMPokemon
    
    var body: some View {
        VStack {
            PokemonImageView(id: pokemon.id ?? 0, types: PokemonType.getTypeStrings(from: pokemon.types ?? []), silhouette: false)
            Text(pokemon.name?.capitalized ?? "")
                .font(.callout)
            HStack {
                ForEach(PokemonType.getTypeStrings(from: pokemon.types ?? []), id: \.self) { type in
                    Text(type)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
