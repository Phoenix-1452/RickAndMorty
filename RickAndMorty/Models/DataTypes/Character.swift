//
//  Character.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import Foundation

// MARK: - Character
struct Character: Codable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: Origin
    let location: SingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct SingleLocation: Codable {
    let name: String
    let url: String
}

// MARK: - Origin
struct Origin: Codable {
    let name: String
    let url: String
}

// MARK: - CharacterStatus
enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

// MARK: - CharacterStatus
enum CharacterGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .male, .female, .genderless:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}


