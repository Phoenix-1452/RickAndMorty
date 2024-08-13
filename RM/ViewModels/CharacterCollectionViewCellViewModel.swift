//
//  CharacterCollectionViewCellViewModel.swift
//  RM
//
//  Created by Vlad Sadovodov on 24.05.2024.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
}

final class CharacterCollectionViewCellViewModel: Hashable, Equatable {
    
    public let characterName: String
    private let characterStatus: CharacterStatus
    public let characterImageURL: URL?
    public var isLiked: Bool
//    var didChange: (() -> Void)?
    
    static func == (lhs: CharacterCollectionViewCellViewModel, rhs: CharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
        hasher.combine(isLiked)
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
    
    public func fetchData(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = characterImageURL else {
            completion(.failure(.badURL))
            return
        }
        ImageLoader.shared.loadImage(url, completion: completion)
    }
}
