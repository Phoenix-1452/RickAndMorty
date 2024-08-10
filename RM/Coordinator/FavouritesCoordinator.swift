////
////  FavouritesCoordinator.swift
////  RM
////
////  Created by Vlad Sadovodov on 24.07.2024.
////
//
//import Foundation
//import UIKit
//
//class FavouritesCoordinator: Coordinator {
//    var navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let viewModel = CharacterListViewViewModel()
//        let likedCharacterListView = LikedCharactersListView(viewModel: viewModel)
//        let favouritesVC = FavouritesCharactersViewController(characterListView: likedCharacterListView)
//        favouritesVC.coordinator = self
//        navigationController.pushViewController(favouritesVC, animated: false)
//    }
//
//    // Метод для показа деталей персонажа
//    func showCharacterDetail(viewModel: CharacterDetailViewViewModel) {
//        let detailVC = CharacterDetailViewController(viewModel: viewModel)
//        navigationController.pushViewController(detailVC, animated: true)
//    }
//}
