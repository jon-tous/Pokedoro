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
    @State private var ownedPokemon = PokemonCollection()
    @State private var pokemonEvolutions = [String: Set<String>]() // ["eevee" : ["vaporeon", "jolteon", "flareon"...]] // ["bulbasaur" : ["ivysaur"]]
    @State private var selection: PKMPokemon?
    
    enum SortMethod: String, CaseIterable {
        case byIDNumber = "Sort by ID"
        case byType = "Sort by Type"
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
                            PokemonImageView(id: pokemon.id ?? 1, types: PokemonType.getTypeStrings(from: pokemon.types ?? []), silhouette: true)
                                .frame(width: 160, height: 160)
                            HStack {
                                Text(pokemon.name?.capitalized ?? "")
                                    .font(.callout)
                                if hasEvolution(pokemon: pokemon) && allEvolutionsOwned(for: pokemon) {
                                    Label("Evolution available", systemImage: "arrow.up")
                                        .labelStyle(.iconOnly)
                                        .font(.caption).bold()
                                }
                            }
                            HStack {
                                ForEach(PokemonType.getTypeStrings(from: pokemon.types ?? []), id: \.self) { type in
                                    Text(type)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onTapGesture { selection = pokemon }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Pokédex")
            .task {
                await populatePokemonList()
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
            }
            .toolbar {
                ToolbarItem {
                    Picker("Sort", selection: $currentSortMethod) {
                        ForEach(SortMethod.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
        }
        }
    }
    
    func populatePokemonList() async {
        for num in 1...Generation.LastIDInGeneration.gen1.rawValue {
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
                    pokemonEvolutions[name] = nextEvolutions
                }
            } catch {
                print("Error loading pokemon with ID \(num)")
            }
        }
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
    
    func hasEvolution(pokemon: PKMPokemon) -> Bool {
        if let name = pokemon.name {
            if let hasNoEvolutions = pokemonEvolutions[name]?.isEmpty {
                return !hasNoEvolutions
            }
        }
        return false
    }
    
    // TODO: test when user collected pokemon feature is built out
    func allEvolutionsOwned(for pokemon: PKMPokemon) -> Bool {
        if let evolutions = pokemonEvolutions[pokemon.name!] {
            for evolution in evolutions {
                if !(ownedPokemon.allNames.contains(evolution)) {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func sortByType() {
        sortByID()
        pokemonList.sort { $0.types?.first?.type?.name ?? "A" < $1.types?.first?.type?.name ?? "B" }
    }
    
    func sortByID() {
        pokemonList.sort { $0.id! < $1.id! }
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
