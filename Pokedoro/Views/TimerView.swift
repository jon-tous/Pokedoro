//
//  TimerView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/21/23.
//

import PokemonAPI
import SwiftUI

struct TimerView: View {
    @EnvironmentObject var pokemonAPI: PokemonAPI
    @EnvironmentObject var collection: PokemonCollection
    
    @State private var countdownTime = CGFloat(TimerInfo.timerLength * 60)
    @Binding var timerRunning: Bool
    
    @State private var newPokemon: PKMPokemon?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let strokeStyle = StrokeStyle(lineWidth: 15, lineCap: .round)
    
    var countdownColor: Color {
        switch(countdownTime) {
        case CGFloat(TimerInfo.timerLength * 60 / 2)...: return .accentColor
        case CGFloat(TimerInfo.timerLength * 60 / 4)...: return .accentColor.opacity(0.75)
        default: return .accentColor.opacity(0.5)
        }
    }
    
    var buttonIcon: String { timerRunning ? "pause" : "play" }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), style: strokeStyle)
            Circle()
                .trim(from: 0, to: 1 - ((CGFloat(TimerInfo.timerLength * 60) - countdownTime) / CGFloat(TimerInfo.timerLength * 60)))
                .stroke(countdownColor, style: strokeStyle)
                .rotationEffect(.degrees(90))
                .animation(.easeInOut, value: countdownTime)
            HStack(spacing: 25) {
                Label("", systemImage: buttonIcon)
                    .font(.title)
                    .onTapGesture {
                        timerRunning.toggle()
                    }
                Text("\(Int(countdownTime/60)):\(countdownTime.truncatingRemainder(dividingBy: 60) < 10 ? "0" : "")\(Int(countdownTime.truncatingRemainder(dividingBy: 60)))")
                    .font(.largeTitle)
                Label("", systemImage: "stop")
                    .font(.title)
                    .onTapGesture {
                        timerRunning = false
                        countdownTime = CGFloat(TimerInfo.timerLength * 60)
                    }
            }
        }
        .fontWeight(.medium)
        .frame(width: 300, height: 300)
        .onReceive(timer) { _ in
            guard timerRunning else { return }
            if countdownTime > 0 {
                countdownTime -= 1
            } else {
                timerRunning = false
                countdownTime = CGFloat(TimerInfo.timerLength * 60)
                Task { await discoverPokemon() }
            }
        }
        .onChange(of: TimerInfo.timerLength) { _ in
            timerRunning = false
            countdownTime = CGFloat(TimerInfo.timerLength * 60)
        }
        .sheet(item: $newPokemon) { pokemon in
            DiscoveredPokemonView(newPokemon: $newPokemon)
                .onDisappear { newPokemon = nil }
        }
    }
    
    /// Future: disallow numbers already in collectedPokémon; handle if someone has discovered all available pokémon, restrict pokemon discovery to first-level evolutions
    func discoverPokemon() async {
        let randNum = Int.random(in: 1...Generation.LastIDInGeneration.gen1.rawValue)
        
        if let pokemon = try? await pokemonAPI.pokemonService.fetchPokemon(randNum) {
            newPokemon = pokemon
            collection.ownedPokemon.append(pokemon)
        } else {
            print("Error loading pokemon with ID \(randNum)")
        }
    }
}

struct TimerInfo {
    @AppStorage("timerLength") static var timerLength = 25
    
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerRunning: .constant(false))
            .environmentObject(PokemonAPI())
            .environmentObject(PokemonCollection())
    }
}
