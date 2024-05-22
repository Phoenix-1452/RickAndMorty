//
//  Location.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import Foundation

struct Location: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
