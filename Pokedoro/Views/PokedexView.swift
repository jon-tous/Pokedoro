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
    @EnvironmentObject var collection: PokemonCollection
    @EnvironmentObject var pokemonEvolutions: PokemonEvolutions
    
    @State private var pokemonList = [PKMPokemon]()
    @State private var selection: PKMPokemon?
    
    enum SortMethod: String, CaseIterable {
        case byIDNumber = "Sort by ID"
        case byType = "Sort by Type"
        case byDiscovered = "Sort by Discovered"
    }
    @State private var currentSortMethod: SortMethod = .byIDNumber
    
    let columns = [GridItem(.adaptive(minimum: 120))]

    var body: some View {
        ZStack {
            BackgroundGradient()
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(pokemonList, id: \.id) { pokemon in
                        VStack {
                            PokemonImageView(id: pokemon.id ?? 1,
                                             types: PokemonType.getTypeStrings(from: pokemon.types ?? []),
                                             silhouette: !collection.ownedPokemon.contains(pokemon))
                                .frame(width: 160, height: 160)
                            PokemonTitleView(pokemon: pokemon)
                        }
                        .onTapGesture { selection = pokemon }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Pokédex")
            .task {
                if pokemonList.count < Generation.LastIDInGeneration.gen1.rawValue {
                    await populatePokemonList()
                }
            }
            .sheet(item: $selection) { selectedPokemon in
                PokemonDetailView(pokemon: selectedPokemon)
            }
            .onChange(of: currentSortMethod) { newValue in
                if newValue == SortMethod.byIDNumber {
                    sortByID()
                }
                else if newValue == SortMethod.byType {
                    sortByType()
                }
                else if newValue == SortMethod.byDiscovered {
                    sortByDiscovered()
                }
            }
            .toolbar {
                ToolbarItem {
                    Picker("Sort", selection: $currentSortMethod) {
                        ForEach(SortMethod.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("\(collection.ownedPokemon.count)/\(Generation.LastIDInGeneration.gen1.rawValue)")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    func populatePokemonList() async {
        for num in 1...Generation.LastIDInGeneration.gen1.rawValue {
            if pokemonList.contains(where: { $0.id == num }) { continue }
            do {
                let pokemon = try await pokemonAPI.pokemonService.fetchPokemon(num)
                let species = try await pokemonAPI.pokemonService.fetchPokemonSpecies(num)
                print("appending \(pokemon.name ?? "") (\(pokemon.id ?? -1)) - \(species.name ?? "") (species ID \(species.id ?? -1))")
                pokemonList.append(pokemon)
                
                if let evolutionChainID = Int((species.evolutionChain?.url?.split(separator: "/").last)!), let name = pokemon.name {
                    
                    var nextEvolutions = Set<String>()
                    
                    if let evolutionChain = try await pokemonAPI.evolutionService.fetchEvolutionChain(evolutionChainID).chain {
                        
                        var curLink = evolutionChain // starts as base evolution chain link
                        
                        // Keep following chain links until we get to the species for this pokemon
                        while curLink.species?.name != species.name {
                            if let nextLinks = curLink.evolvesTo {
                                for link in nextLinks {
                                    // Follow each evolution path searching for species name
                                    if let foundSpeciesLink = searchEvolutionPath(forName: species.name, startingAt: link) {
                                        curLink = foundSpeciesLink
                                        break
                                    }
                                }
                            }
                        }
                        
                        // Now we have the correct species in the chain
                        if curLink.species?.name == species.name {
                            // we want to insert all next evolvesTo into the set
                            if let evolutionOptions = curLink.evolvesTo {
                                for evolutionOption in evolutionOptions {
                                    nextEvolutions.insert(evolutionOption.species?.name ?? "")
                                }
                            }
                        }
                    }
                    print("evolves to \(nextEvolutions.description)")
                    pokemonEvolutions.pokemonEvolutions[name] = nextEvolutions
                }
            } catch {
                print("Error loading pokemon with ID \(num)")
            }
        }
        print(pokemonEvolutions.pokemonEvolutions.debugDescription)
    }
    
    func searchEvolutionPath(forName name: String?, startingAt root: PKMClainLink) -> PKMClainLink? {
        guard let name = name else { return nil }
        
        // Success case
        if root.species?.name == name { return root }
        
        // Continue search on its children
        while root.evolvesTo != nil && !root.evolvesTo!.isEmpty {
            // recurse on its children, stopping to return the chain link if name matches
            
            if let nextLinks = root.evolvesTo {
                for link in nextLinks {
                    // Follow each evolution path searching for species name
                    if let foundSpeciesLink = searchEvolutionPath(forName: name, startingAt: link) {
                        return foundSpeciesLink
                    }
                }
            }
        }
        return nil
    }
    
    func sortByType() {
        sortByID()
        pokemonList.sort { $0.types?.first?.type?.name ?? "A" < $1.types?.first?.type?.name ?? "B" }
    }
    
    func sortByID() {
        pokemonList.sort { $0.id! < $1.id! }
    }
    
    func sortByDiscovered() {
        sortByID()
        pokemonList.sort { collection.ownedPokemon.contains($0) && !collection.ownedPokemon.contains($1) ? true : false }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PokedexView()
                .environmentObject(PokemonAPI())
                .environmentObject(PokemonCollection())
                .environmentObject(PokemonEvolutions())
        }
    }
}
