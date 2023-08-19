//
//  PokemonTitleView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 8/18/23.
//

import PokemonAPI
import SwiftUI

struct PokemonTitleView: View {
    @EnvironmentObject var collection: PokemonCollection
    @EnvironmentObject var pokemonEvolutions: PokemonEvolutions
    
    let pokemon: PKMPokemon
    let useTypeColors: Bool
    
    var body: some View {
        let displayName = collection.ownedPokemon.contains(pokemon) ? (pokemon.name?.capitalized ?? "") : "???"
        let displayTypes = collection.ownedPokemon.contains(pokemon) ? PokemonType.getTypeStrings(from: pokemon.types ?? []) : ["Type(s) unknown"]
        
        return VStack {
            HStack {
                Text(displayName)
                    .font(.headline)
                    .fontWeight(.medium)
                if hasEvolution(pokemon: pokemon) && allEvolutionsOwned(for: pokemon) {
                    evolvableIcon
                }
            }
            HStack {
                ForEach(displayTypes, id: \.self) { type in
                    Text(type)
                        .font(.subheadline)
                        .fontWeight(useTypeColors ? .medium : .regular)
                        .foregroundColor(useTypeColors ? Color(type) : .secondary)
                }
            }
        }
    }
    
    var evolvableIcon: some View {
        Label("Evolution available", systemImage: "arrow.up")
            .labelStyle(.iconOnly)
            .font(.caption).bold()
    }
    
    func hasEvolution(pokemon: PKMPokemon) -> Bool {
        if let name = pokemon.name {
            if let hasNoEvolutions = pokemonEvolutions.pokemonEvolutions[name]?.isEmpty {
                return !hasNoEvolutions
            }
        }
        return false
    }
    
    // TODO: test when user collected pokemon feature is built out
    // TODO: have to populate this logic once all pokemon have been loaded
    func allEvolutionsOwned(for pokemon: PKMPokemon) -> Bool {
        if let evolutions = pokemonEvolutions.pokemonEvolutions[pokemon.name!] {
            for evolution in evolutions {
                if (collection.allNames.contains(evolution) == false) { // pokemonEvolutions.keys.contains(evolution) &&
                    return false
                }
            }
            return true
        }
        return false
    }
}
