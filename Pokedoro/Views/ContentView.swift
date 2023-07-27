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
            ExploreView()
                .tabItem { Label("Explore", systemImage: "figure.walk") }.tag(0)
            NavigationStack {
                PokedexView()
            }
            .tabItem { Label("Pokédex", systemImage: "text.book.closed.fill") }.tag(1)
            ZStack {
                BackgroundGradient()
                Text("Choose a Pokémon with an evolution available to train!")
            }
            .tabItem { Label("Train", systemImage: "sportscourt") }.tag(2)
            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PokemonAPI())
    }
}
