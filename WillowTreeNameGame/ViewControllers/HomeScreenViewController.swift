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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playGame(_ sender: UIButton) {
        print("button tapped")
        let vc = storyboard?.instantiateViewController(withIdentifier: "NameGameVC") as! NameGameViewController
        present(vc, animated: true)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
