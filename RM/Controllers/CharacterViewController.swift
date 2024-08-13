//
//  CharacterViewController.swift
//  RM
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import UIKit
import Combine

final class CharacterViewController: UIViewController {
    
    private let characterListView: CharacterListView
    private let viewModel: CharacterListViewViewModel
    private var cancellables = Set<AnyCancellable>()
    var coordinator: CharactersCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Characters"
        let backButton = UIBarButtonItem()
        backButton.title = "Characters"
        self.navigationItem.backBarButtonItem = backButton
        view.addSubview(characterListView)
        setUpView()
        setupBindings()
        viewModel.fetchCharacters()
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
        viewModel.didFetchNewData
            .receive(on: RunLoop.main)
            .sink { [weak self] indexPaths in
            self?.characterListView.insertItems(at: indexPaths)
            }
            .store(in: &cancellables)

        viewModel.didUpdateData
            .receive(on: RunLoop.main)
            .sink { [weak self] indexPaths in
            self?.characterListView.reloadItems(at: indexPaths)
            }
            .store(in: &cancellables)
    }
}


extension CharacterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModels = viewModel.cellViewModels[indexPath.row]
        let character = viewModel.characters[indexPath.row]

        cell.onLikeButtonTapped = { [weak self] in
            self?.viewModel.likeCharacter(character)
            self?.characterListView.reloadItems(at: [indexPath])
        }
        cell.configure(with: viewModels)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        coordinator?.showCharacterDetail(for: character)  // Используем координатор для перехода

//        if let navigationController = self.navigationController {
//            navigationController.pushViewController(detailViewController, animated: true)
//        } else {
//            print("Navigation Controller is not available")
//        }
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
        guard viewModel.hasMorePages else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard viewModel.hasMorePages else { return }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.viewModel.fetchCharacters()
            }
            t.invalidate()
        }
    }
}

    
