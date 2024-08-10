import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    private func setUpTabs() {
        // Создаем общий ViewModel, который будет использоваться двумя контроллерами
        let viewModel = CharacterListViewViewModel()

        // Создаем первый контроллер для всех персонажей
        let charactersVC = createCharactersViewController(viewModel: viewModel)

        // Создаем второй контроллер для лайкнутых персонажей
        let favouritesVC = createFavouritesViewController(viewModel: viewModel)

        // Настраиваем вкладки и навигационные контроллеры
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

        setViewControllers([charactersNav, favouritesNav], animated: true)
    }
    
    private func createCharactersViewController(viewModel: CharacterListViewViewModel) -> UIViewController {
        let charactersVC = CharacterViewController(viewModel: viewModel) // Передаем ViewModel во ViewController
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        return charactersVC
    }
    
    private func createFavouritesViewController(viewModel: CharacterListViewViewModel) -> UIViewController {
        let favouritesVC = FavouritesCharactersViewController(viewModel: viewModel) // Передаем ViewModel во ViewController
        favouritesVC.navigationItem.largeTitleDisplayMode = .automatic
        return favouritesVC
    }
}
