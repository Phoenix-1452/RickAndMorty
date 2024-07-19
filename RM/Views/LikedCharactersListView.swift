import UIKit
import Combine

class LikedCharactersListView: UIView {
    
    private let viewModel: CharacterListViewViewModel
    private var cancellables = Set<AnyCancellable>()
    private var models: [CharacterCollectionViewCellViewModel?] = []
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = false
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    init(viewModel: CharacterListViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubViews(collectionView, spinner)
        addConstraints()
//        viewModel.fetchLikedCharacters()       
        setupBindings()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func setupBindings() {
//        viewModel.$likedCellViewModels
//            .receive(on: RunLoop.main)
//            .sink { [weak self] _ in
//                self?.collectionView.reloadData()
//                print("Liked Cell View Models Updated (Binding): \(self?.viewModel.likedCellViewModels.map { $0.characterName } ?? [])")
//            }
//            .store(in: &cancellables)
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.spinner.startAnimating()
                    self?.collectionView.isHidden = true
                } else {
                    self?.spinner.stopAnimating()
                    self?.collectionView.isHidden = false
                    self?.collectionView.alpha = 0
                    UIView.animate(withDuration: 0.4) {
                        self?.collectionView.alpha = 1
                    }
                }
            }
            .store(in: &cancellables)
        viewModel.$cellViewModels
            .receive(on: RunLoop.main)
            .sink { [weak self] asd in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        collectionView.dataSource = self
        collectionView.delegate = self

    }
}

extension LikedCharactersListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(viewModel.likedCellViewModels.count)
        return viewModel.cellViewModels.filter( {$0.isLiked == true} ).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let likedViewModel = viewModel.cellViewModels.filter { $0.isLiked }[indexPath.row]
        guard let character = viewModel.characters.filter( {$0.name == likedViewModel.characterName} ).first else {
            fatalError("Unsupported cell")
        }
      
        cell.onLikeButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.likeCharacter(character)
            
            let updatedIndexPath = self.collectionView.indexPath(for: cell)
            
            if let indexPath = updatedIndexPath {
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: [indexPath])
                }, completion: nil)
            }
        }
        cell.configure(with: likedViewModel)


        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
}
