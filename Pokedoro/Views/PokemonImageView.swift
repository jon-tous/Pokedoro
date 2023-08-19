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
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.8)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .task { await fetchImageURL() }
    }
    
    /// Get image url from microservice based on pokemon ID and silhouette param
    ///
    /// Note: Currently, the image service is locally hosted
    private func fetchImageURL() async -> Void {
        let imageServiceBaseURL = "http://localhost:3000/pokemon/"
        
        // Get image entry URL for this pokemon ID
        guard let pokemonImagesEntryURL = URL(string: imageServiceBaseURL + String(id)) else {
            print("invalid image entry URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: pokemonImagesEntryURL)
            if let decodedResponse = try? JSONDecoder().decode(ImageAPIResponse.self, from: data) {
                if silhouette == false {
                    imageUrl = URL(string: decodedResponse.imageUrl)
                } else {
                    imageUrl = URL(string: decodedResponse.silhouetteImageUrl)
                }
            }
        } catch {
            print("Invalid image entry response")
        }
    }
}

struct PokemonImageView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonImageView(id: 13, types: ["Grass", "Poison"], silhouette: true)
            .frame(width: 300, height: 300)
    }
}
