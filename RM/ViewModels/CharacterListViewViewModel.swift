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
    @Published var isLoading: Bool = false
    @Published var cellViewModels: [CharacterCollectionViewCellViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    public var apiInfo: GetAllCharactersResponse.Info? = nil
    
    public var hasMorePages = true
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreCharacters = false
    
    private var currentPage = 1

    let didFetchNewData = PassthroughSubject<[IndexPath], Never>()
    
    let didUpdateData = PassthroughSubject<[IndexPath], Never>()

    override init() {
        super.init()
        setupBindings()
    }

    public func likeCharacter(_ character: Character) {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index].isLiked?.toggle()
            cellViewModels[index].isLiked.toggle()
        }
    }
    
    public func dislikeCharacter(_ character: Character) {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            print(index)
            characters[index].isLiked?.toggle()
            cellViewModels[index].isLiked.toggle()
            let indexPathsToAdd: [IndexPath] = Array(arrayLiteral: index).compactMap({
                return IndexPath(row: $0, section: 0)
            })
            DispatchQueue.main.async {
                self.didUpdateData.send(indexPathsToAdd)
            }
        }
    }
    

    func fetchCharacters() {
        guard !isLoading && hasMorePages else { return }

        isLoading = true
        let url = ("https://rickandmortyapi.com/api/character?page=\(currentPage)")
        
        NetworkingManager.shared.fetchData(from: url, type: GetAllCharactersResponse.self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
                self.isLoading = false
            }, receiveValue: { [weak self] (responseModel: GetAllCharactersResponse) in
                guard let self = self else { return }
                self.isLoading = false
                
                let moreResults = responseModel.results
                let info = responseModel.info
                self.apiInfo = info

                let originalCount = self.characters.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                self.characters.append(contentsOf: moreResults)

                self.hasMorePages = responseModel.info.next != nil
                if self.hasMorePages {
                    self.currentPage += 1
                }
                DispatchQueue.main.async {
                    self.didFetchNewData.send(indexPathsToAdd)
                }

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
        for character in characters {
            let newViewModel = CharacterCollectionViewCellViewModel(
                characterName: character.name,
                characterStatus: character.status,
                characterImageURL: URL(string: character.image),
                isLiked: character.isLiked ?? false
            )
            if !cellViewModels.contains(newViewModel) {
                cellViewModels.append(newViewModel)
            }
        }
    }
}
