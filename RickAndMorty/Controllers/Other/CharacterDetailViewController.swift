//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 26.05.2024.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
    
    init(viewModel: CharacterDetailViewViewModel) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
