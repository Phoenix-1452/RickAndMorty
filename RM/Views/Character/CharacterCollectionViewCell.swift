//
//  CharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 24.05.2024.
//

import UIKit
import SDWebImage

/// Single cell for a character
class CharacterCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "CharacterCollectionViewCell"
    var onLikeButtonTapped: (() -> Void)?
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubViews(imageView, nameLabel, statusLabel, likeButton)
        addConstraints()
        setupCornerRadius()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),
            
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
        ])
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        onLikeButtonTapped?()
    }
    
    private func setupCornerRadius() {
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        likeButton.isSelected = false
    }
    
    //    public func configure(with viewModel: CharacterCollectionViewCellViewModel) {
    //        // Устанавливаем текстовые данные
    //        nameLabel.text = viewModel.characterName
    //        statusLabel.text = viewModel.characterStatusText
    //        likeButton.isSelected = viewModel.isLiked
    //
    //        // Очищаем изображение перед загрузкой нового
    //        imageView.image = nil
    //
    //        // Создаем локальную переменную для хранения текущего viewModel
    //        let currentViewModel = viewModel
    //
    //        // Асинхронная загрузка изображения
    //        viewModel.fetchData { [weak self] result in
    //            guard let self = self else { return }
    //
    //            // Проверка, что viewModel всё ещё соответствует текущему
    //            guard currentViewModel === viewModel else { return }
    //
    //            switch result {
    //            case .success(let data):
    //                DispatchQueue.main.async {
    //                    // Проверяем еще раз на соответствие перед установкой изображения
    //                    if currentViewModel === viewModel, let image = UIImage(data: data) {
    //                        self.imageView.image = image
    //                    }
    //                }
    //            case .failure(let error):
    //                print("Failed to load image: \(error)")
    //            }
    //        }
    //    }
    
    public func configure(with viewModel: CharacterCollectionViewCellViewModel) {
        // Устанавливаем текстовые данные
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        likeButton.isSelected = viewModel.isLiked
        
        // Загрузка изображения с использованием SDWebImage
        if let url = viewModel.characterImageURL {
            imageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground, .retryFailed], completed: nil)
        } else {
            imageView.image = nil // Убираем изображение, если URL отсутствует
        }
    }
}
