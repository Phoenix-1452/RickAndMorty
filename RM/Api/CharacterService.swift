//
//  NetworkingManager.swift
//  RM
//
//  Created by Vlad Sadovodov on 07.07.2024.
//

import Foundation
import Combine

class CharacterService {
    static let shared = CharacterService()
    private init() {}
    
    func fetchCharacters() -> AnyPublisher<[Character], Error> {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: GetAllCharactersResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}



