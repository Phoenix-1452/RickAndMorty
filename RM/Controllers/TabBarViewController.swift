//
//  TabBarViewController.swift
//  RM
//
//  Created by Vlad Sadovodov on 30.06.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    private func setUpTabs() {
        let viewModel = CharacterListViewViewModel()
        
        let characterListView = CharacterListView(viewModel: viewModel)
        let charactersVC = CharacterViewController(characterListView: characterListView)
        
        let likedCharacterListView = LikedCharactersListView(viewModel: viewModel)
        let favouritesVC = FavoritesCharactersViewController(characterListView: likedCharacterListView)

        
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        favouritesVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let charactersNav = UINavigationController(rootViewController: charactersVC)
        let favouritesNav = UINavigationController(rootViewController: favouritesVC)

        
        charactersNav.tabBarItem = UITabBarItem(title: "Characters",
                                       image: UIImage(systemName: "eyes"),
                                       tag: 1)
        favouritesNav.tabBarItem = UITabBarItem(title: "Favourites",
                                       image: UIImage(systemName: "heart"),
                                       tag: 2)
        
        
        for nav in [charactersNav, favouritesNav] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([charactersNav, favouritesNav],
                           animated: true)

    }

}

