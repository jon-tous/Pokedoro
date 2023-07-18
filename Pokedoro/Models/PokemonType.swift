//
//  PokemonType.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/18/23.
//

import SwiftUI

enum PokemonType: String, Codable, Identifiable {
    var id: Self { self }
    
    case Grass
    case Poison
    case Fire
    case Flying
    case Water
    case Bug
    case Normal
    case Electric
    case Ground
    case Fairy
    case Fighting
    case Psychic
    case Rock
    case Steel
    case Ice
    case Ghost
    case Dragon
    case Dark
    
    static func getSymbolFromType(type: PokemonType) -> String {

        switch type {
        case .Grass:
            return "leaf"
        case .Poison:
            return "allergens"
        case .Fire:
            return "flame"
        case .Flying:
            return "tornado"
        case .Water:
            return "drop"
        case .Bug:
            return "ladybug"
        case .Normal:
            return "pawprint"
        case .Electric:
            return "bolt"
        case .Ground:
            return "globe.americas.fill"
        case .Fairy:
            return "sparkles"
        case .Fighting:
            return "hand.raised"
        case .Psychic:
            return "wave.3.right"
        case .Rock:
            return "diamond"
        case .Steel:
            return "gearshape"
        case .Ice:
            return "snowflake"
        case .Ghost:
            return "aqi.medium"
        case .Dragon:
            return "swift"
        case .Dark:
            return "moon"
        }
    }
}
