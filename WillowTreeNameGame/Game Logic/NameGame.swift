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
    func startGame(with gameData : (selectedNamesArray : [NamesDataModel], correctAnswer : Int), gameType : GameType)
}
enum GameType {
    case normal, matt, teams
}
class NameGame {
    var stringArray = [String]()
    weak var delegate: NameGameDelegate?

    let numberPeople = 6
    var score = 0
    
    func generateNamesArray(withFilter : GameType) {
        var modelData = [NamesDataModel]()
        switch withFilter {
        case .normal:
            modelData = NamesDataStore().getNamesData(forGame: .normal)
            print("normal mode")
            print(modelData)
        case .matt:
            print("Matt Mode")
            modelData = NamesDataStore().getNamesData(forGame: .matt)
            print(modelData)
        case .teams:
            print("Team Mode")
            modelData = NamesDataStore().getNamesData(forGame: .teams)
            print(modelData)
        }
        modelData = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: modelData) as! [NamesDataModel]
        let modelSlice = Array(modelData[0...5])
        let correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: numberPeople)
        self.delegate?.startGame(with: (modelSlice, correctAnswer), gameType: withFilter)
    }
    
}
