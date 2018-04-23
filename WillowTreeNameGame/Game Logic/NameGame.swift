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
}

class NameGame {
    var modelData = Array(NamesDataStore().getNamesData())
    var stringArray = [String]()
    weak var delegate: NameGameDelegate?

    let numberPeople = 6
    var score = 0
    func startGame() {
    }
    
    func evaluateChoice(_ sender : UIButton) {
        if sender.tag == 0 {
            print("correct")
            score += 1
        } else {
            print("incorrect")
        }
    }
    
    func generateNamesArray() -> (selectedNamesArray : [NamesDataModel], correctAnswer : Int) {
        modelData = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: modelData) as! [NamesDataModel]
        let modelSlice = Array(modelData[0...5])
        let correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: numberPeople)
        return (modelSlice, correctAnswer)
    }
    
    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {

    }
}
