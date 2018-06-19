//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import GameplayKit

protocol NameGameDelegate: class {
    func startGame(with gameData: (selectedNamesArray: [NamesDataModel], correctAnswer: Int), gameType: GameType)
}
enum GameType: Int {
    case normal = 0, matt, teams
}
class NameGame {

    weak var delegate: NameGameDelegate?

    let numberPeople = 6
    
    func generateNamesArray(withFilter: GameType) {
        var modelData = [NamesDataModel]()
        switch withFilter {
        case .normal:
            modelData = NamesDataStore().getNamesData(forGame: .normal)
        case .matt:
            modelData = NamesDataStore().getNamesData(forGame: .matt)
        case .teams:
            modelData = NamesDataStore().getNamesData(forGame: .teams)
        }
        
        modelData = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: modelData) as! [NamesDataModel]
        let modelSlice = Array(modelData[0...5])
        let correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: numberPeople)
        self.delegate?.startGame(with: (modelSlice, correctAnswer), gameType: withFilter)
    }
    
}
