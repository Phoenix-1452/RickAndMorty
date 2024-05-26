//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 24.05.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
}

final class CharacterCollectionViewCellViewModel {
    
    public let characterName: String
    private let characterStatus: CharacterStatus
    private let characterImageURL: URL?
    
    init(characterName: String, characterStatus: CharacterStatus, characterImageURL: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
    }
    
    public var characterStatusText: String {
        return characterStatus.rawValue
    }
    
    public func fetchData(competion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = characterImageURL else {
            competion(.failure(.badURL))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                competion(.failure(.requestFailed))
                return
            }
            competion(.success(data))
        }
        task.resume()
    }
}
