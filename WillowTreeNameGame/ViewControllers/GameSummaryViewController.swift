//
//  GameSummaryViewController.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/25/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import UIKit

class GameSummaryViewController: UIViewController {

    @IBOutlet weak var attemptsLabel: UILabel!
    @IBOutlet weak var averageTimeToCorrectLabel: UILabel!
    @IBOutlet weak var totalCorrect: UILabel!
    
    var scoreDataArray : [ScoreData]?
    
    private var timeToCorrect : Double {
        // grab abs value difference of time started and time completed
        // sum the value
        // divide by number correct
        // return
        return 0.0
    }
    private var numberOfAttemptsPerGame : Int {
        // sum attempts per game
        // divide by # correct
        
        return 0
    }
    private var totalCorrectGames : Int {
        
        return 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setSummaryLabels()
        
    }
    func injectScoreData(scoreDataArray : [ScoreData]) {
        self.scoreDataArray = scoreDataArray
    }
    
    private func setSummaryLabels() {
        averageTimeToCorrectLabel.text = "Avg. time to correct: \(timeToCorrect)"
        attemptsLabel.text = "Avg. attempts per round: \(numberOfAttemptsPerGame)"
        totalCorrect.text = "Total Correct Names: \(totalCorrectGames)"
    }

    @IBAction func homeTapped(_ sender: UIButton) {
        let homeVC = storyboard?.instantiateInitialViewController() as! HomeScreenViewController
        present(homeVC, animated: true)
    }
}
