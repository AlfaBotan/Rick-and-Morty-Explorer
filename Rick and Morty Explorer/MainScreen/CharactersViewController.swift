//
//  CharactersViewController.swift
//  Rick and Morty Explorer
//
//  Created by Илья Волощик on 11.03.25.
//

import UIKit
import SwiftUI

final class CharactersViewController: UIViewController {
    
    private let charactersLoadServise = CharactersLoadServise()
    private let transitionAnimator = CharacterTransitionAnimator()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search by name or status"
        searchBar.delegate = self
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = .darkGray
        return searchBar
    }()
    
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
        navigationController?.delegate = self
        configSubviews()
        configConstraints()
        setUpBinding()
        charactersLoadServise.loadData()
    }
    
    private func configSubviews() {
        view.addSubview(searchBar)
        view.addSubview(charactersTableView)
    }
    
    private func configConstraints() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            charactersTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            charactersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            charactersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            charactersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpBinding() {
        charactersLoadServise.reloadTableView = { [weak self] in
            guard let self = self else {return}
            self.charactersTableView.reloadData()
        }
    }
    
}

//MARK: UITableViewDelegate and UITableViewDataSource

extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let char = charactersLoadServise.getChar(index: indexPath.row)
        let swiftUIView = DetailView(character: char)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        
        if let cell = tableView.cellForRow(at: indexPath) as? CharactersTableViewCell {
            transitionAnimator.selectedCellFrame = cell.getImageFrame()
        }
        
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        charactersLoadServise.tableViewWillDisplay(RowAt: indexPath.row)
    }
}

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersLoadServise.numberOfCharacters()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.identifer, for: indexPath) as? CharactersTableViewCell else {
            assertionFailure("Не удалось выполнить приведение к CharactersTableViewCell")
            return UITableViewCell()
        }
        
        let char = charactersLoadServise.getChar(index: indexPath.row)
        let name = char.name
        let status = StatusEnum(rawValue: char.status) ?? StatusEnum.unknown
        let urlForImage = URL(string: char.image)
        cell.configCell(name: name, status: status, image: urlForImage)
        return cell
    }
}

//MARK: UINavigationControllerDelegate

extension CharactersViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.isPresenting = operation == .push
        return transitionAnimator
    }
}

extension CharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        charactersLoadServise.filterCharacters(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

