//
//  GetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 17.05.2024.
//

import Foundation

struct GetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [Character]
}
