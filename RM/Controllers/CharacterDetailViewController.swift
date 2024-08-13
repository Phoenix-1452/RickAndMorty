//
//  CharacterDetailViewController.swift
//  RM
//
//  Created by Vlad Sadovodov on 18.07.2024.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    private let viewModel: CharacterDetailViewViewModel
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CharacterInfoCell.self, forCellReuseIdentifier: "CharacterInfoCell")
        tableView.register(CharacterHeaderCell.self, forCellReuseIdentifier: "CharacterHeaderCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
        
    init(viewModel: CharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension CharacterDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 // 1 ячейка для аватара и имени + 6 ячеек для информации
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterHeaderCell", for: indexPath) as! CharacterHeaderCell
            cell.configure(with: viewModel)
            cell.selectionStyle = .none // Добавляем эту строку
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterInfoCell", for: indexPath) as! CharacterInfoCell
            let info: (title: String, value: String) = {
                switch indexPath.row {
                case 1: return ("Gender", viewModel.gender)
                case 2: return ("Status", viewModel.status)
                case 3: return ("Species", viewModel.species)
                case 4: return ("Origin", viewModel.origin)
                case 5: return ("Location", viewModel.location)
                case 6: return ("Type", viewModel.type)
                default: return ("", "")
                }
            }()
            cell.configure(title: info.title, value: info.value)
            cell.selectionStyle = .none // Добавляем эту строку
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 300 : 55
    }
    
}
