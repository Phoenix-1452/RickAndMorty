////
////  Coordinator.swift
////  RM
////
////  Created by Vlad Sadovodov on 24.07.2024.
////
//
//import Foundation
//import UIKit
//
//protocol Coordinator {
//    var navigationController: UINavigationController { get set }
//    func start()
//}
//
//class MainCoordinator: Coordinator {
//    var navigationController: UINavigationController
//    var tabBarController: UITabBarController
//
////    private var charactersCoordinator: CharactersCoordinator?
//    private var favouritesCoordinator: FavouritesCoordinator?
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//        self.tabBarController = UITabBarController()
//    }
//
//    func start() {
//        let charactersNav = UINavigationController()
//        let favouritesNav = UINavigationController()
//
//        charactersCoordinator = CharactersCoordinator(navigationController: charactersNav)
//        favouritesCoordinator = FavouritesCoordinator(navigationController: favouritesNav)
//
//        charactersCoordinator?.start()
//        favouritesCoordinator?.start()
//
//        charactersNav.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "eyes"), tag: 1)
//        favouritesNav.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "heart"), tag: 2)
//
//        tabBarController.setViewControllers([charactersNav, favouritesNav], animated: false)
//        navigationController.pushViewController(tabBarController, animated: false)
//    }
//}
