//
//  Episode.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
