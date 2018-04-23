//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
    
    let nGame = NameGame()
    var correctAnswer = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        
        print(imageButtons)
        let gameData = nGame.generateNamesArray()
        configureFaces(from: gameData.selectedNamesArray)
        print(gameData.selectedNamesArray)
        correctAnswer = gameData.correctAnswer
        print(correctAnswer)
        
        print(gameData.selectedNamesArray[correctAnswer].firstName)
        print(gameData.selectedNamesArray[correctAnswer].headShotURL)
        
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        print("Button Tapped")
        print(button.tag)
        if button.tag == correctAnswer {
            print("Correct")
        } else {
            print("Wrong")
        }
    }
    
    func configureFaces(from arrayModel : [NamesDataModel]) {
        for (idx, button) in imageButtons.enumerated() {
            if let imageString = arrayModel[idx].headShotURL {
                button.convertURLToImage(urlString: imageString ) { image in
                    button.imageView?.contentMode = .scaleAspectFit
                    button.setImage(image, for: .normal)
                }
            }
            button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor(red: 0.37, green: 0.73, blue: 0.70, alpha: 1.0).cgColor
        }
    }

    func configureSubviews(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }

        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation: UIDeviceOrientation = size.height > size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
}

extension NameGameViewController: NameGameDelegate {
}
