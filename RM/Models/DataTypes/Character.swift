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
    var isLiked: Bool?

}

extension Character: Equatable {
    enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url, created
    }
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(CharacterStatus.self, forKey: .status)
        species = try container.decode(String.self, forKey: .species)
        type = try container.decode(String.self, forKey: .type)
        gender = try container.decode(CharacterGender.self, forKey: .gender)
        origin = try container.decode(Origin.self, forKey: .origin)
        location = try container.decode(SingleLocation.self, forKey: .location)
        image = try container.decode(String.self, forKey: .image)
        episode = try container.decode([String].self, forKey: .episode)
        url = try container.decode(String.self, forKey: .url)
        created = try container.decode(String.self, forKey: .created)
        isLiked = false  // Устанавливаем значение по умолчанию
    }
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

// MARK: - CharacterGender
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


