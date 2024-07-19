//
//  CharacterDetailViewController.swift
//  RM
//
//  Created by Vlad Sadovodov on 18.07.2024.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    private let viewModel: CharacterDetailViewViewModel

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
    
    init(viewModel: CharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
