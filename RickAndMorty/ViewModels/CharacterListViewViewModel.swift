//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 21.05.2024.
//

import Foundation
import UIKit

final class CharacterListViewViewModel: NSObject {
    
    public func fetchCharacters() {
        Service.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Example image url: "+String(model.results.first?.image ?? "None"))

            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
}

extension CharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? CharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = CharacterCollectionViewCellViewModel(
            characterName: "Afraz",
            characterStatus: .alive,
            characterImageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(
            width: width, height: width * 1.5
        )
    }
}
