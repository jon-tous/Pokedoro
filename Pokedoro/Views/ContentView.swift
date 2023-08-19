//
//  ContentView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/17/23.
//

import SwiftUI
import PokemonAPI

struct ContentView: View {
    @EnvironmentObject var collection: PokemonCollection
    
    @State private var selectedTab = 1
    
    let trainingUnlockLevel = 10
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView()
                .tabItem { Label("Catch", systemImage: "figure.walk") }.tag(0)
            
            NavigationStack { PokedexView() }
                .tabItem { Label("Pokédex", systemImage: "text.book.closed.fill") }.tag(1)
            
            Group {
                if collection.ownedPokemon.count < trainingUnlockLevel {
                    LockedView(unlockLevel: trainingUnlockLevel, currentLevel: collection.ownedPokemon.count)
                        .tabItem { Label("???", systemImage: "lock") }
                } else {
                    TrainingView()
                        .tabItem { Label("Train", systemImage: "sportscourt") }
                }
            }.tag(2)
            
            NavigationStack { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gearshape") }.tag(3)
        }
        .onAppear(perform: adjustTabBarConfig)
    }
    
    /// Fixes bug with iOS 15+ tab bar background
    func adjustTabBarConfig() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PokemonAPI())
            .environmentObject(PokemonCollection())
            .environmentObject(PokemonEvolutions())
    }
}
