//
//  CharacterViewController.swift
//  RM
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import UIKit
import Combine

class CharacterViewController: UIViewController {
    
    private let characterListView: CharacterListView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"

        view.addSubview(characterListView)
        setUpView()
    }
    
    init(characterListView: CharacterListView) {
        self.characterListView = characterListView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
}
    
