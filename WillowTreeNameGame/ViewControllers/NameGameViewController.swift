//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController, NameGameDelegate {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
   
    var nameGame : NameGame?
    
    var correctAnswer = 0
    var selectedNames = [NamesDataModel]()
    var gameTypeSelected : GameType?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = AppConstants().willowTreeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
    
    func setGameGenerator(with nameGame : NameGame, forGameType : GameType) {
        self.nameGame = nameGame
        nameGame.delegate = self
        nameGame.generateNamesArray(withFilter: forGameType)
    }
    
    // MARK : - Protocol method implementation
    func startGame(with gameData: (selectedNamesArray: [NamesDataModel], correctAnswer: Int), gameType : GameType) {
        correctAnswer = gameData.correctAnswer
        selectedNames = gameData.selectedNamesArray
        gameTypeSelected = gameType
        print("Game Started")
        configureFaces(from: gameData.selectedNamesArray) {
            view in
            UIViewController.removeSpinner(spinner: view)
        }
        let correctUser = gameData.selectedNamesArray[gameData.correctAnswer]
        questionLabel.text = "Who is \(correctUser.fullName())"
    }
    
    @IBAction func faceTapped(_ button: FaceButton) {
        if button.tag == correctAnswer {
            print("Correct. Say hi to \(selectedNames[correctAnswer].fullName())")
            // create new names and start again.
            guard let gameTypeSelected = gameTypeSelected else { return }
            nameGame?.generateNamesArray(withFilter: gameTypeSelected)
        } else {
            print("you selected \(selectedNames[button.tag].fullName())")
        }
    }
    
    // MARK : - Setup Views
    func configureFaces(from arrayModel : [NamesDataModel], completion: @escaping (UIView) -> Void) {
        let sv = UIViewController.displaySpinner(onView: self.view)
            for (idx, button) in self.imageButtons.enumerated() {
                
                if let imageString = arrayModel[idx].headShotURL {
                    button.convertURLToImage(urlString: imageString ) { image in
                        button.imageView?.contentMode = .scaleAspectFit
                        button.setImage(image, for: .normal)
                        
                    }
                }
                button.layer.borderWidth = 2.0
                button.layer.borderColor = AppConstants().willowTreeColor.cgColor
            }
            completion(sv)
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

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = AppConstants().willowTreeColor
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    class func removeSpinner(spinner : UIView) {
        DispatchQueue.main.async {
            print("Removing")
            spinner.removeFromSuperview()
            
        }
    }
}
