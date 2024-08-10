////
////  CharactersCoordinator.swift
////  RM
////
////  Created by Vlad Sadovodov on 24.07.2024.
////
//
//import Foundation
//import UIKit
//
//class CharactersCoordinator: Coordinator {
//    var navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let viewModel = CharacterListViewViewModel()
//        let characterListView = CharacterListView(viewModel: viewModel)
//        let charactersVC = CharacterViewController(characterListView: characterListView)
//        charactersVC.coordinator = self
//        navigationController.pushViewController(charactersVC, animated: false)
//    }
//
//    // Метод для показа деталей персонажа
//    func showCharacterDetail(viewModel: CharacterDetailViewViewModel) {
//        let detailVC = CharacterDetailViewController(viewModel: viewModel)
//        navigationController.pushViewController(detailVC, animated: true)
//    }
//}
