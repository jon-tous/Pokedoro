//
//  PokedexView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/17/23.
//

import PokemonAPI
import SwiftUI

struct PokedexView: View {
    @EnvironmentObject var pokemonAPI: PokemonAPI
    @State private var pokemonList = [PKMPokemon]()
    
    let availableIDs = 1...151
    
    let columns = [GridItem(.adaptive(minimum: 120))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(pokemonList, id: \.id) { pokemon in
                    VStack {
                        PokemonImageView(id: pokemon.id ?? 1, types: getTypeStrings(from: pokemon.types ?? []))
                            .frame(width: 160, height: 160)
                        Text(pokemon.name?.capitalized ?? "")
                            .font(.callout)
                        HStack {
                            ForEach(getTypeStrings(from: pokemon.types ?? []), id: \.self) { type in
                                Text(type)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Pokédex")
        .task {
            await populatePokemonList()
        }
    }
    
    func populatePokemonList() async {
        for num in 1...151 {
            do {
                let pokemon = try await pokemonAPI.pokemonService.fetchPokemon(num)
                print("appending \(pokemon)")
                pokemonList.append(pokemon)
            } catch {
                print("Error loading pokemon with ID \(num)")
            }
        }
    }
    
    func getTypeStrings(from typeArray: [PKMPokemonType]) -> [String] {
        typeArray.compactMap { $0.type?.name?.capitalized }
    }

}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PokedexView()
                .environmentObject(PokemonAPI())
        }
    }
}
