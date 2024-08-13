//
//  FavouritesCoordinator.swift
//  RM
//
//  Created by Vlad Sadovodov on 24.07.2024.
//

import Foundation
import UIKit

final class FavouritesCoordinator: Coordinator {
    var navigationController: UINavigationController
    let viewModel: CharacterListViewViewModel
    
    init(navigationController: UINavigationController, viewModel: CharacterListViewViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let favouritesVC = FavouritesCharactersViewController(viewModel: viewModel)
        favouritesVC.coordinator = self
        favouritesVC.navigationItem.largeTitleDisplayMode = .automatic
        navigationController.pushViewController(favouritesVC, animated: false)
    }
    
    // Пример метода для показа деталей персонажа
    func showCharacterDetail(for character: Character) {
        let detailViewModel = CharacterDetailViewViewModel(character: character)
        let detailVC = CharacterDetailViewController(viewModel: detailViewModel)

        navigationController.pushViewController(detailVC, animated: true)
    }
}
