//
//  FavoritesCharactersViewController.swift
//  RM
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import UIKit
import Combine

final class FavouritesCharactersViewController: UIViewController {
    
    private let characterListView: CharacterListView
    private let viewModel: CharacterListViewViewModel
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Favourites"
        let backButton = UIBarButtonItem()
        backButton.title = "Favourites"
        self.navigationItem.backBarButtonItem = backButton
        view.addSubview(characterListView)
        setUpView()
        setupBindings()
    }
    
    init(viewModel: CharacterListViewViewModel) {
        self.viewModel = viewModel
        self.characterListView = CharacterListView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        characterListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        characterListView.setDataSource(self)
        characterListView.setDelegate(self)
    }
    
    private func setupBindings() {
        viewModel.$characters
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.characterListView.reloadData()
            }
            .store(in: &cancellables)
    }
}


extension FavouritesCharactersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.filter( {$0.isLiked == true} ).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let likedViewModel = viewModel.cellViewModels.filter { $0.isLiked }[indexPath.row]
        guard let character = viewModel.characters.filter( {$0.image == likedViewModel.characterImageURL?.absoluteString} ).first else {
            fatalError("Unsupported cell")
        }
      
        cell.onLikeButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.dislikeCharacter(character)
            
            let updatedIndexPath = self.characterListView.indexPath(for: cell)
            
            if let indexPath = updatedIndexPath {
                self.characterListView.deleteItems(at: [indexPath])
            }
        }
        cell.configure(with: likedViewModel)


        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Получаем выбранного персонажа из массива characters
        let character = viewModel.characters.filter({$0.isLiked == true})[indexPath.row]

        // Создаем ViewModel и ViewController для деталей персонажа
        let detailViewModel = CharacterDetailViewViewModel(character: character)
        let detailViewController = CharacterDetailViewController(viewModel: detailViewModel)
        
        // Переход к экрану деталей
        if let navigationController = self.navigationController {
            navigationController.pushViewController(detailViewController, animated: true)
        } else {
            print("Navigation Controller is not available")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
}

