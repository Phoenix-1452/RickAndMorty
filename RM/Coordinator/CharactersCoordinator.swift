//
//  CharactersCoordinator.swift
//  RM
//
//  Created by Vlad Sadovodov on 24.07.2024.
//

import Foundation
import UIKit

final class CharactersCoordinator: Coordinator {
    var navigationController: UINavigationController
    let viewModel: CharacterListViewViewModel
    
    init(navigationController: UINavigationController, viewModel: CharacterListViewViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let charactersVC = CharacterViewController(viewModel: viewModel)
        charactersVC.coordinator = self
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        navigationController.pushViewController(charactersVC, animated: false)
    }
    
    func showCharacterDetail(for character: Character) {
        let detailViewModel = CharacterDetailViewViewModel(character: character, imageLoader: ImageLoader())
        let detailVC = CharacterDetailViewController(viewModel: detailViewModel)

        navigationController.pushViewController(detailVC, animated: true)
    }
}
