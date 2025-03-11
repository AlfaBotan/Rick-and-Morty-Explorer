//
//  CharactersLoadServise.swift
//  Rick and Morty Explorer
//
//  Created by Илья Волощик on 11.03.25.
//

import Foundation
import rick_morty_swift_api
import ProgressHUD

final class CharactersLoadServise {
    
    private let rmClient = RMClient()
    
    private var characterModelsArray: [CharacterModel] = []
    private var filteredCharacterModelsArray: [CharacterModel] = []
    private var numberOFpage = 1
    private var currentSearchText: String = ""
    
    var reloadTableView: (() -> Void)?
    
    func loadData() {
        rmClient.character().getCharactersByPageNumber(pageNumber: numberOFpage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let characterModels):
                    self.characterModelsArray += characterModels
                    self.applyFilter()
                    self.numberOFpage += 1
                    self.reloadTableView?()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func filterCharacters(by searchText: String) {
        currentSearchText = searchText
        applyFilter()
    }
    
    private func applyFilter() {
        if currentSearchText.isEmpty {
            filteredCharacterModelsArray = characterModelsArray
        } else {
            filteredCharacterModelsArray = characterModelsArray.filter { character in
                character.name.lowercased().contains(currentSearchText.lowercased()) ||
                character.status.lowercased().contains(currentSearchText.lowercased())
            }
        }
        reloadTableView?()
    }
    
    func tableViewWillDisplay(RowAt indexPath: Int) {
        let lastIndexPath = filteredCharacterModelsArray.count - 1
        if indexPath == lastIndexPath {
            loadData()
        }
    }
    
    func numberOfCharacters() -> Int {
        return filteredCharacterModelsArray.count
    }
    
    func getChar(index: Int) -> CharacterModel {
        return filteredCharacterModelsArray[index]
    }
}
