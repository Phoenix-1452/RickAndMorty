//
//  CharacterDetailViewViewModel.swift
//  RM
//
//  Created by Vlad Sadovodov on 26.05.2024.
//

import Foundation

final class CharacterDetailViewViewModel {
    
    private let character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
