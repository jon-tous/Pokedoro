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
    let silhouette: Bool
    
    @State var imageUrl: URL?
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(
                    .linearGradient(Gradient(colors: types.compactMap { Color($0) }), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.3)
                )
            if imageUrl != nil {
                AsyncImage(url: imageUrl) { image in
                    image
                        .renderingMode(silhouette ? .template : .original)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.8)
                        .foregroundColor(.black.opacity(0.8)) // only affects the silhouette, not the original image
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .task { await fetchImageURL() }
    }
    
    private func fetchImageURL() async -> Void {
        let baseImageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
        guard let url = URL(string: baseImageURL + String(id) + ".png") else {
            print("invalid image url for id \(id)")
            return
        }
        imageUrl = url
    }
}

struct PokemonImageView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonImageView(id: 13, types: ["Grass", "Poison"], silhouette: false)
            .frame(width: 300, height: 300)
    }
}
