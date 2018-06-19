//
//  FeedbackPopupViewController.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/25/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import UIKit

protocol FeedbackPopupDelegate: class {
    func continueGame(buttonSelected: String?, isCorrect: Bool?)
    func endGame()
}

class FeedbackPopupViewController: UIViewController {

    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var employeeImageView: UIImageView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeTitleLabel: UILabel!
    
    weak var popupDelegate: FeedbackPopupDelegate?
    weak var nameGameDelegate: NameGameDelegate?
    var nameSelected: NamesDataModel?
    var nameSelectedImage: UIImage?
    var isCorrect: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBox.layer.cornerRadius = 15
        viewBox.layer.masksToBounds = true
        
        fillFeedbackPopup()
        // Do any additional setup after loading the view.
    }
    
    func injectUserData(namesData: NamesDataModel, userImage: UIImage, isCorrect: Bool) {
        self.nameSelected = namesData
        self.nameSelectedImage = userImage
        self.isCorrect = isCorrect
    }
    
    func fillFeedbackPopup() {
        if let isCorrect = isCorrect {
            feedbackLabel.text = isCorrect ? "Correct!" : "Incorrect. Try Again!"
        } else {
            feedbackLabel.text = "Sorry. Feedback not sent."
        }
        employeeImageView.image = nameSelectedImage
        employeeNameLabel.text = nameSelected?.fullName()
        employeeTitleLabel.text = nameSelected?.employeeTitle()
    }
    
    @IBAction func continueGameTapped(_ sender: UIButton) {
        dismiss(animated: true) {
        self.popupDelegate?.continueGame(buttonSelected: sender.titleLabel?.text, isCorrect: self.isCorrect)
        }
    }
    
    @IBAction func endGameTapped(_ sender: UIButton) {
        
        dismiss(animated: true) { self.popupDelegate?.endGame() }
    }
    
}
