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
    @Published var filteredCharacters: [Character] = []

    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var cellViewModels: [CharacterCollectionViewCellViewModel] = []
    @Published var filteredCellViewModels: [CharacterCollectionViewCellViewModel] = []

    
    private var cancellables = Set<AnyCancellable>()
    
//    public var apiInfo: GetAllCharactersResponse.Info? = nil
    
    public var hasMorePages = true
    public var filteredHasMorePages = true

    
//    public var shouldShowLoadMoreIndicator: Bool {
//        return apiInfo?.next != nil
//    }
    
    public var isLoadingMoreCharacters = false
    
    private var currentPage = 1
    var filteredCurrentPage = 1

    let didFetchNewData = PassthroughSubject<[IndexPath], Never>()
    let didUpdateData = PassthroughSubject<[IndexPath], Never>()
    let didFilter = PassthroughSubject<Void, Never>()

    
    let characterLoader: NetworkManaging
//    let imageLoader: ImageLoading
    
    private var currentQuery: String = ""
    
    init(characterLoader: NetworkManaging) {
        self.characterLoader = characterLoader
//        self.imageLoader = imageLoader
        super.init()
        setupBindings()
    }

    func likeCharacter(_ character: Character) {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index].isLiked?.toggle()
            cellViewModels[index].isLiked.toggle()
//            filteredCharacters[index].isLiked?.toggle()
//            filteredCellViewModels[index].isLiked.toggle()
        }
//        if let index = filteredCharacters.firstIndex(where: { $0.id == character.id }) {
//            filteredCharacters[index].isLiked?.toggle()
//            filteredCellViewModels[index].isLiked.toggle()
//        }
    }
    
    func dislikeCharacter(_ character: Character) {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
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
            
        characterLoader.fetchData(from: url, type: GetAllCharactersResponse.self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error: \(error.localizedDescription)")
                    }
//                    self.isLoading = false
                }, receiveValue: { [weak self] (responseModel: GetAllCharactersResponse) in
                    guard let self = self else { return }
                    let moreResults = responseModel.results
                    let originalCount = self.characters.count
                    let newCount = moreResults.count
                    let total = originalCount+newCount
                    let startingIndex = total - newCount
                    
                    let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                        return IndexPath(row: $0, section: 0)
                    })
                    for character in moreResults {
                        if !characters.contains(character) {
                            self.characters.append(character)
                        }
                    }
//                    self.characters.append(contentsOf: moreResults)
                    updateCellViewModels(with: characters)
                    self.filteredCharacters = self.characters
                    self.filteredCellViewModels = self.cellViewModels
                    
                    self.hasMorePages = responseModel.info.next != nil
                    
                    if self.hasMorePages {
                        self.currentPage += 1
                    }
                    
                    DispatchQueue.main.async {
                        self.didFetchNewData.send(indexPathsToAdd)
                        self.isLoading = false
                    }
                })
                .store(in: &cancellables)
    }
    
    func getCharacters() {
        filteredCharacters = characters
        filteredCellViewModels = cellViewModels
        DispatchQueue.main.async {
            self.didFilter.send()
        }
    }
    
    func fetchCharacters(byName query: String) {
        
        if query != currentQuery {
            filteredCurrentPage = 1
            filteredCharacters.removeAll()
            filteredCellViewModels.removeAll()
            currentQuery = query // Обновляем текущий запрос
            filteredHasMorePages = true
            print("removed")
        }
        
        guard !isLoading && filteredHasMorePages else { return }

        isLoading = true

        // Формируем URL для запроса с учетом имени персонажа
        let url = "https://rickandmortyapi.com/api/character/?page=\(filteredCurrentPage)&name=\(query)"
//        print("Fetching page \(filteredCurrentPage) for query: \(query)")

        characterLoader.fetchData(from: url, type: GetAllCharactersResponse.self)
            .sink(receiveCompletion: { completion in
                // Обрабатываем завершение запроса
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
                // Сбрасываем флаг загрузки
//                self.isLoading = false
            }, receiveValue: { [weak self] (responseModel: GetAllCharactersResponse) in
                guard let self = self else { return }

                // Получаем результаты с текущей страницы
                let moreResults = responseModel.results
                print("count \(responseModel.info.count)")
                // Определяем начальные и конечные индексы для обновления коллекции
//                let originalCount = self.filteredCharacters.count
//                let newCount = moreResults.count
//                let total = originalCount + newCount
//                let startingIndex = total - newCount
//                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).map({
//                    return IndexPath(row: $0, section: 0)
//                })
//                print(moreResults.count)
                // Добавляем новые результаты к отфильтрованным персонажам
                for character in moreResults {
                    if !characters.contains(character) {
                        self.characters.append(character)
                    }
                }
                updateCellViewModels(with: moreResults)
                self.filteredCharacters.append(contentsOf: moreResults)
                updateFilteredCellViewModels(with: self.filteredCharacters)
                // Определяем, есть ли еще страницы для загрузки
                self.filteredHasMorePages = responseModel.info.next != nil
                if self.filteredHasMorePages {
                    self.filteredCurrentPage += 1
                }

                // Обновляем интерфейс на главном потоке
                DispatchQueue.main.async {
                    self.didFilter.send()
                    self.isLoading = false
                }

            })
            .store(in: &cancellables)
    }

    private func setupBindings() {
//        $characters
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] characters in
//                self?.updateCellViewModels(with: characters)
////                self?.filteredCharacters = self!.characters
////                self?.filteredCellViewModels = self!.cellViewModels
//            }
//            .store(in: &cancellables)
//        $filteredCharacters
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] filteredCharacters in
//                self?.updateFilteredCellViewModels(with: filteredCharacters)
//            }
//            .store(in: &cancellables)
        
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
//        filteredCellViewModels = cellViewModels
    }
    
    private func updateFilteredCellViewModels(with characters: [Character]) {
        for character in characters {
            let newViewModel = CharacterCollectionViewCellViewModel(
                characterName: character.name,
                characterStatus: character.status,
                characterImageURL: URL(string: character.image),
                isLiked: character.isLiked ?? false
            )
            
            if !filteredCellViewModels.contains(newViewModel) {
                filteredCellViewModels.append(newViewModel)
            }
        }

    }
}
