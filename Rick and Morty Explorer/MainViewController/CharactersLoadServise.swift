//
//  CharactersLoadServise.swift
//  Rick and Morty Explorer
//
//  Created by Илья Волощик on 11.03.25.
//

import Foundation
import rick_morty_swift_api

final class CharactersLoadServise {
    
    private let rmClient = RMClient()
    private var characterModelsArray: [CharacterModel] = []
    
    var reloadTableView: (() -> Void)?
    
    func loadData() {
        rmClient.character().getCharactersByPageNumber(pageNumber: 1) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let characterModels):
                    self.characterModelsArray += characterModels
                    self.reloadTableView?()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func numberOfCharacters() -> Int {
        return characterModelsArray.count
    }
    
    func getChar(index: Int) -> CharacterModel {
        return characterModelsArray[index]
    }
}
