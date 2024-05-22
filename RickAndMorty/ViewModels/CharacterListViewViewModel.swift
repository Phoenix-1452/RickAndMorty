//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 21.05.2024.
//

import Foundation
import UIKit

final class CharacterListViewViewModel: NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    
    func fetchCharacters() {
        Service.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Total: "+String(model.info.count))
                print("Page result count: "+String(model.results.count))

            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
}
