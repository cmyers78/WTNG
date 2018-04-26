//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
   
    // injected properties
    var scoreData : ScoreData?
    var nameGame : NameGame?
    var gameTypeSelected : GameType?
    
    // local storage of generated data
    var scoreDataArray = [ScoreData?]()
    var correctAnswer = Int()
    var selectedNames = [NamesDataModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = AppConstants.willowTreeColor
        print("view appearing soon")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
    
    func setGameGenerator(with nameGame : NameGame, forGameType : GameType, scoreData : ScoreData) {
        self.nameGame = nameGame
        self.scoreData = scoreData
        nameGame.delegate = self
        nameGame.generateNamesArray(withFilter: forGameType)
    }
    
    private func obtainFeedback(namesData : NamesDataModel, userImage : UIImage, correctAnswer : Bool) {
        let popupVC = storyboard?.instantiateViewController(withIdentifier: AppConstants.feedbackPopupVC) as! FeedbackPopupViewController
        popupVC.injectUserData(namesData: namesData, userImage: userImage, isCorrect: correctAnswer)
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func faceTapped(_ button: FaceButton) {
        let nameSelected = selectedNames[button.tag]
        guard let image = button.imageView?.image else { return }
        var isCorrect = false
        
        if button.tag == correctAnswer {
            scoreData?.foundCorrectName = true
            isCorrect = true
            scoreData?.timeToCorrect = Date().timeIntervalSince1970
        } else {
            scoreData?.attempts += 1
        }
        obtainFeedback(namesData: nameSelected, userImage: image, correctAnswer: isCorrect)
        
    }
    
    
    // MARK : - Setup Views
    private func configureFaces(from arrayModel : [NamesDataModel], completion: @escaping (UIView) -> Void) {
        let sv = UIViewController.displaySpinner(onView: self.view)
            for (idx, button) in self.imageButtons.enumerated() {
                
                if let imageString = arrayModel[idx].headShotURL {
                    button.convertURLToImage(urlString: imageString ) { image in
                        button.imageView?.contentMode = .scaleAspectFit
                        button.setImage(image, for: .normal)
                    }
                }
                button.layer.borderWidth = 2.0
                button.layer.borderColor = UIColor.black.cgColor
            }
            completion(sv)

    }
    private func configureSubviews(_ orientation: UIDeviceOrientation) {
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

// MARK: - Protocol Extensions
extension NameGameViewController : NameGameDelegate, FeedbackPopupDelegate {
    func endGame() {
        scoreDataArray.append(scoreData)
        let summaryVC = storyboard?.instantiateViewController(withIdentifier: AppConstants.gameSummaryVC) as! GameSummaryViewController
        summaryVC.injectScoreData(scoreDataArray: scoreDataArray as! [ScoreData])
        present(summaryVC, animated: true)
    }
    
    func continueGame(buttonSelected: String?, isCorrect: Bool?) {
        var continueGame : Bool {
            return buttonSelected == AppConstants.feedbackContinueButtonTitle
        }
        guard let isCorrect = isCorrect else { return }
        if continueGame && isCorrect {
            scoreDataArray.append(scoreData)
            nameGame?.generateNamesArray(withFilter: gameTypeSelected!)
        }
    }
    
    func startGame(with gameData: (selectedNamesArray: [NamesDataModel], correctAnswer: Int), gameType : GameType) {
        correctAnswer = gameData.correctAnswer
        selectedNames = gameData.selectedNamesArray
        gameTypeSelected = gameType
        print("Game Started")
        configureFaces(from: gameData.selectedNamesArray) {
            view in
            // I know this is probably a horrible hack, but I could not find another way to implement it.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                UIViewController.removeSpinner(spinner: view)
                }
        }
        let correctUser = gameData.selectedNamesArray[gameData.correctAnswer]
        questionLabel.text = "Who is \(correctUser.fullName())"
        scoreData?.timeStarted = Date().timeIntervalSince1970
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = AppConstants.willowTreeColor
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
            spinner.removeFromSuperview()
            
        }
    }
}
