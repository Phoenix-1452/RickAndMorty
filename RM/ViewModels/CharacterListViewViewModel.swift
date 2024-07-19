//
//  CharacterListViewViewModel.swift
//  RM
//
//  Created by Vlad Sadovodov on 24.05.2024.
//


import Combine
import Foundation
import UIKit


final class CharacterListViewViewModel: NSObject {
    @Published var characters: [Character] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = true
    @Published var cellViewModels: [CharacterCollectionViewCellViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        setupBindings()
    }

    func likeCharacter(_ character: Character) {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index].isLiked?.toggle()
            cellViewModels[index].isLiked.toggle()
        }
    }
    
    func fetchCharacters() {
        isLoading = true
        CharacterService.shared.fetchCharacters()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { characters in
                self.characters = characters
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    private func setupBindings() {
        $characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] characters in
                self?.updateCellViewModels(with: characters)
            }
            .store(in: &cancellables)
        
    }

    private func updateCellViewModels(with characters: [Character]) {
        cellViewModels = characters.map { character in
            CharacterCollectionViewCellViewModel(
                characterName: character.name,
                characterStatus: character.status,
                characterImageURL: URL(string: character.image),
                isLiked: character.isLiked ?? false
            )
        }
    }
}
