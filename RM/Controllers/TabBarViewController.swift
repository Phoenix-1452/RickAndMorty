//import UIKit
//
//final class TabBarViewController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpTabs()
//    }
//    
//    private func setUpTabs() {
//        let viewModel = CharacterListViewViewModel()
//
//        let charactersVC = createCharactersViewController(viewModel: viewModel)
//        let favouritesVC = createFavouritesViewController(viewModel: viewModel)
//
//        let charactersNav = UINavigationController(rootViewController: charactersVC)
//        let favouritesNav = UINavigationController(rootViewController: favouritesVC)
//
//        charactersNav.tabBarItem = UITabBarItem(title: "Characters",
//                                                image: UIImage(systemName: "eyes"),
//                                                tag: 1)
//        favouritesNav.tabBarItem = UITabBarItem(title: "Favourites",
//                                                image: UIImage(systemName: "heart"),
//                                                tag: 2)
//
//        for nav in [charactersNav, favouritesNav] {
//            nav.navigationBar.prefersLargeTitles = true
//        }
//
//        setViewControllers([charactersNav, favouritesNav], animated: true)
//    }
//    
//    private func createCharactersViewController(viewModel: CharacterListViewViewModel) -> UIViewController {
//        let charactersVC = CharacterViewController(viewModel: viewModel)
//        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
//        return charactersVC
//    }
//    
//    private func createFavouritesViewController(viewModel: CharacterListViewViewModel) -> UIViewController {
//        let favouritesVC = FavouritesCharactersViewController(viewModel: viewModel)
//        favouritesVC.navigationItem.largeTitleDisplayMode = .automatic
//        return favouritesVC
//    }
//}
