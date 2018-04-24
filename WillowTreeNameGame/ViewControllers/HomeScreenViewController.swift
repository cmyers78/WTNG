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
    
    @IBAction func playGame(_ sender: UIButton) {
        print("button tapped")
        let vc = storyboard?.instantiateViewController(withIdentifier: "NameGameVC") as! NameGameViewController
        vc.setGameGenerator(with: NameGame(), forGameType: .normal)
        present(vc, animated: true)
    }

}
