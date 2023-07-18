//
//  PokemonImageView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/18/23.
//

import SwiftUI

struct PokemonImageView: View {
    let id: Int
    let types: [String]
    
    let baseImageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
    
    var body: some View {
        if let url = URL(string: baseImageURL + String(id) + ".png") {
            ZStack {
                Circle()
                    .foregroundStyle(.linearGradient(
                        Gradient(colors: types.compactMap { Color($0) }),
                        startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.3)
                    )
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.8)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
}

struct PokemonImageView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonImageView(id: 13, types: ["Grass", "Poison"])
            .frame(width: 300, height: 300)
    }
}
