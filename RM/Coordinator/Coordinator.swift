//
//  Coordinator.swift
//  RM
//
//  Created by Vlad Sadovodov on 24.07.2024.
//

import Foundation
import UIKit



protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    private let viewModel: CharacterListViewViewModel
    private let window: UIWindow

    // Храним координаторы как свойства
    private var characterCoordinator: CharactersCoordinator?
    private var favouritesCoordinator: FavouritesCoordinator?
    let diContainer = DIContainer()


    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.tabBarController = UITabBarController()
        
//        diContainer.register(ImageLoading.self) {
//            ImageLoader()
//        }
        diContainer.register(NetworkManaging.self) {
            NetworkingManager()
        }
        
        self.viewModel = CharacterListViewViewModel(
            characterLoader: diContainer.resolve(NetworkManaging.self)
//            imageLoader: diContainer.resolve(ImageLoading.self)
        )
    }

    func start() {
        let characterCoordinator = CharactersCoordinator(navigationController: UINavigationController(), viewModel: viewModel)
        let favouritesCoordinator = FavouritesCoordinator(navigationController: UINavigationController(), viewModel: viewModel)

        // Сохраняем сильные ссылки на координаторы
        self.characterCoordinator = characterCoordinator
        self.favouritesCoordinator = favouritesCoordinator

        characterCoordinator.start()
        favouritesCoordinator.start()

        tabBarController.setViewControllers([
            characterCoordinator.navigationController,
            favouritesCoordinator.navigationController
        ], animated: false)

        characterCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Characters",
                                                                            image: UIImage(systemName: "eyes"),
                                                                            tag: 1)
        favouritesCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Favourites",
                                                                             image: UIImage(systemName: "heart"),
                                                                             tag: 2)

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
