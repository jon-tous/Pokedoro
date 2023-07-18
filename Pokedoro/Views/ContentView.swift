//
//  ContentView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/17/23.
//

import SwiftUI
import PokemonAPI

struct ContentView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Go into a region and have a random encounter")
                .tabItem { Label("Explore", systemImage: "figure.walk") }.tag(0)
            NavigationStack {
                PokedexView()
            }
                .tabItem { Label("Pokédex", systemImage: "text.book.closed.fill") }.tag(1)
            Text("Choose a Pokémon with an evolution available")
                .tabItem { Label("Train", systemImage: "sportscourt") }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PokemonAPI())
    }
}
