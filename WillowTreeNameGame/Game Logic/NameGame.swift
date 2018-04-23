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
    func startGame(with gameData : (selectedNamesArray : [NamesDataModel], correctAnswer : Int))
}

class NameGame {
    var modelData = Array(NamesDataStore().getNamesData())
    var stringArray = [String]()
    weak var delegate: NameGameDelegate?

    let numberPeople = 6
    var score = 0
    
    func generateNamesArray() {
        modelData = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: modelData) as! [NamesDataModel]
        let modelSlice = Array(modelData[0...5])
        let correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: numberPeople)
        self.delegate?.startGame(with: (modelSlice, correctAnswer))
    }
    
}
