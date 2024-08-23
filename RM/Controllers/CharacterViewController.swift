//
//  CharacterViewController.swift
//  RM
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import UIKit
import Combine


/// cделать чтобы прогруженные персонажи не добавлялись обратно в персонажей, и были на своих местах по id
/// 
/// сетевой слой
/// кэширование
/// 

final class CharacterViewController: UIViewController {
    
    private let searchController: UISearchController
    private let searchBar: UISearchBar
    
    private let characterListView: CharacterListView
    private let viewModel: CharacterListViewViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: CharactersCoordinator?

    private var scrollEventSubject = PassthroughSubject<Void, Never>()

    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Characters"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Characters"
        self.navigationItem.backBarButtonItem = backButton
        
        view.addSubViews(characterListView, searchBar)
        setUpView()
        setupBindings()
        

    }
    
    init(viewModel: CharacterListViewViewModel) {
        self.viewModel = viewModel
        self.characterListView = CharacterListView()
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchBar = UISearchBar(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Characters"
        searchBar.sizeToFit()
        searchBar.autocapitalizationType = .none
    }
    
    private func setUpView() {
        characterListView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        setupSearchBar()

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            characterListView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        characterListView.setDataSource(self)
        characterListView.setDelegate(self)
        

    }
    
    private func setupBindings() {
        viewModel.didFetchNewData
            .receive(on: RunLoop.main)
            .sink { [weak self] indexPaths in
//                self?.characterListView.insertItems(at: indexPaths)
                self?.characterListView.reloadData()
                self?.isLoading = false

            }
            .store(in: &cancellables)

        viewModel.didUpdateData
            .receive(on: RunLoop.main)
            .sink { [weak self] indexPaths in
                self?.characterListView.reloadItems(at: indexPaths)
            }
            .store(in: &cancellables)
        
        viewModel.didFilter
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                print("FILTERED")
                self?.characterListView.reloadData()
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        scrollEventSubject
            .sink { [weak self] in
                // Проверка текста в строке поиска
                let searchText = self?.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                if !searchText.isEmpty {
                    print("NOT empty \(searchText)")
                    self?.viewModel.fetchCharacters(byName: searchText)

                } else {
                    print("Empty")
                    self?.viewModel.fetchCharacters()
                }
            }
            .store(in: &cancellables)
    }
}

extension CharacterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.fetchCharacters(byName: searchText)

        if searchText.isEmpty {
            viewModel.getCharacters()

//            viewModel.fetchCharacters()
        } else {
            print("Searching.. \(searchText)")
            viewModel.fetchCharacters(byName: searchText)

        }
    }
}


extension CharacterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredCellViewModels.count > 0 ? viewModel.filteredCellViewModels.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
//        print("Filtered cell viewmodels = \(viewModel.filteredCellViewModels.count), index = \(indexPath.row)")
        let viewModels = viewModel.filteredCellViewModels[indexPath.row]
//        print(viewModels.characterName)
        let character = viewModel.filteredCharacters[indexPath.row]
        cell.onLikeButtonTapped = { [weak self] in
            self?.viewModel.likeCharacter(character)
            self?.characterListView.reloadItems(at: [indexPath])
        }
        cell.configure(with: viewModels)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.filteredCharacters[indexPath.row]
        coordinator?.showCharacterDetail(for: character)  // Используем координатор для перехода
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
                for: indexPath) as? FooterLoadingCollectionReusableView
        else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard viewModel.hasMorePages, viewModel.filteredHasMorePages else {
            return .zero
        }

        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoading {
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                scrollEventSubject.send()
                isLoading = true
                print("scrollviewdidload \(isLoading)")

            }
        }
    }
}

    
