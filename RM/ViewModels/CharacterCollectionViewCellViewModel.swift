//
//  CharacterCollectionViewCellViewModel.swift
//  RM
//
//  Created by Vlad Sadovodov on 24.05.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
}

final class CharacterCollectionViewCellViewModel: Hashable, Equatable {
    
    public let characterName: String
    private let characterStatus: CharacterStatus
    private let characterImageURL: URL?
    public var isLiked: Bool
    var didChange: (() -> Void)?
    
    static func == (lhs: CharacterCollectionViewCellViewModel, rhs: CharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
    
    init(characterName: String, characterStatus: CharacterStatus, characterImageURL: URL?, isLiked: Bool) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
        self.isLiked = isLiked
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
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
