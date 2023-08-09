//
//  ImageAPIResponse.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 8/9/23.
//

import Foundation

struct ImageAPIResponse: Codable {
    let name: String
    let pokedexEntry: Int
    let imageUrl: String
    let silhouetteImageUrl: String
}
