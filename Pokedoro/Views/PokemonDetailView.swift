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
            PokemonImageView(id: pokemon.id ?? 0,
                             types: PokemonType.getTypeStrings(from: pokemon.types ?? []),
                             silhouette: !collection.ownedPokemon.contains(pokemon)
            ).padding()
            
            Text(pokemon.name?.capitalized ?? "")
                .font(.largeTitle)
            
            HStack {
                ForEach(pokemon.types ?? [], id: \.self) { type in
                    if let typeString = PokemonType.getTypeStrings(from: [type]).first ?? "" {
                        HStack {
                            Image(systemName: PokemonType.getSymbolFromType(type: PokemonType(rawValue: typeString) ?? PokemonType.Normal))
                            Text(typeString)
                        }
                        .foregroundColor(Color(typeString))
                    }
                }
            }
        }
        .fontWeight(.medium)
    }
}
