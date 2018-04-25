//
//  HomeScreenViewController.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/23/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkRequests().loadNamesFromNetwork()
        print("grab names from db")
        
        // Do any additional setup after loading the view.
    }
    func start(forGameType : GameType) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NameGameVC") as! NameGameViewController
        vc.setGameGenerator(with: NameGame(), forGameType: forGameType, scoreData: ScoreData())
        present(vc, animated: true)
    }
    @IBAction func playGame(_ sender: UIButton) {
        start(forGameType: .normal)
    }

}
