//
//  PokedoroApp.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/17/23.
//

import SwiftUI
import PokemonAPI

@main
struct PokedoroApp: App {
    var body: some Scene {
        WindowGroup {
            let pokemonAPI = PokemonAPI()
            let pokemonCollection = PokemonCollection()
            let pokemonEvolutions = PokemonEvolutions()
            
            ContentView()
                .environmentObject(pokemonAPI)
                .environmentObject(pokemonCollection)
                .environmentObject(pokemonEvolutions)
        }
    }
}
