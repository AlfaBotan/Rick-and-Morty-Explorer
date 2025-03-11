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
    
    private var numberOFpage = 1
    var reloadTableView: (() -> Void)?
    
    func loadData() {
        rmClient.character().getCharactersByPageNumber(pageNumber: numberOFpage) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let characterModels):
                    self.characterModelsArray += characterModels
                    self.numberOFpage += 1
                    self.reloadTableView?()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func tableViewWillDisplay(RowAt indexPath: Int) {
        let lastIndexPath = characterModelsArray.count - 1
        if indexPath == lastIndexPath {
            loadData()
        }
   }
    
    func numberOfCharacters() -> Int {
        return characterModelsArray.count
    }
    
    func getChar(index: Int) -> CharacterModel {
        return characterModelsArray[index]
    }
}
