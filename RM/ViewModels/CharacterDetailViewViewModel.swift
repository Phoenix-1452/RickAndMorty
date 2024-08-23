//
//  CharacterDetailViewViewModel.swift
//  RM
//
//  Created by Vlad Sadovodov on 26.05.2024.
//

import Foundation

final class CharacterDetailViewViewModel {
    
    private let character: Character
    private let imageLoader: ImageLoading

    init(character: Character, imageLoader: ImageLoading) {
        self.character = character
        self.imageLoader = imageLoader
    }
    
    public var title: String {
        name.uppercased()
    }
    
    public var name: String {
        return character.name
    }
    
    public var status: String {
        return character.status.rawValue
    }
    
    public var species: String {
        return character.species
    }
    
    public var type: String {
        return character.type.isEmpty ? "Unknown" : character.type
    }
    
    public var gender: String {
        return character.gender.rawValue
    }
    
    public var origin: String {
        return character.origin.name
    }
    
    public var location: String {
        return character.location.name
    }
    
    public var image: String {
        return character.image
    }
    
    public func fetchData(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: image) else { return  }
        imageLoader.loadImage(url, completion: completion)
    }
}
