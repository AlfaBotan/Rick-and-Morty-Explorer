//
//  CharactersViewController.swift
//  Rick and Morty Explorer
//
//  Created by Илья Волощик on 11.03.25.
//

import UIKit

class CharactersViewController: UIViewController {
    
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharactersTableViewCell.self, forCellReuseIdentifier: CharactersTableViewCell.identifer)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSubviews()
        configConstraints()
    }
    
    private func configSubviews() {
        view.addSubview(charactersTableView)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            charactersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            charactersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            charactersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension CharactersViewController: UITableViewDelegate {
    
}

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.identifer, for: indexPath) as? CharactersTableViewCell else {
            assertionFailure("Не удалось выполнить приведение к CharactersTableViewCell")
            return UITableViewCell()
        }
        let url = URL(string: "https://rickandmortyapi.com/api/character/avatar/361.jpeg")
        cell.configCell(name: "Rick", status: StatusEnum.unknown, image: url!)
        return cell
    }
    
    
}

