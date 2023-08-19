//
//  DiscoveredPokemonView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 8/18/23.
//

import PokemonAPI
import SwiftUI

struct DiscoveredPokemonView: View {
    @Binding var newPokemon: PKMPokemon?
    
    var body: some View {
        if let pokemon = newPokemon {
            VStack {
                Spacer()
                
                Text("Nice work, trainer!")
                    .font(.largeTitle)
                    .padding(.vertical)
                Group {
                    Text(pokemon.name?.capitalized ?? "A Pokémon")
                        .foregroundColor(.accentColor) +
                    Text(" has been added to your Pokédex.")
                        .foregroundColor(.secondary)
                }.font(.headline)
                
                Spacer()
                PokemonDetailView(pokemon: pokemon)
                Spacer()
                
                Button {
                    // Clear newPokemon to dismiss the sheet
                    newPokemon = nil
                } label: { Text("OK") }
                    .buttonStyle(.borderedProminent).tint(.accentColor)
                
                Spacer()
            }
            .fontWeight(.medium)
            .padding(.horizontal)
        }
    }
}
