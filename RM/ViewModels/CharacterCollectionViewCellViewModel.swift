//
//  CharacterCollectionViewCellViewModel.swift
//  RM
//
//  Created by Vlad Sadovodov on 24.05.2024.
//

import Foundation
import Combine
import SDWebImage

enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
}

final class CharacterCollectionViewCellViewModel: Hashable, Equatable {
//    let imageLoader: ImageLoading

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
//        self.imageLoader = imageLoader

    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchData(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = characterImageURL else {
            completion(.failure(.badURL))
            return
        }

        SDWebImageDownloader.shared.downloadImage(with: url, options: [.continueInBackground], progress: nil) { (image, data, error, finished) in
            if let error = error {
                completion(.failure(.requestFailed))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.unknown))
            }
        }
    }
//        imageLoader.loadImage(url, completion: completion)
    
}
