//
//  HomeScreenViewController.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/23/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = (tableView.frame.height * 0.33)
        NetworkRequests().loadNamesFromNetwork()
        print("grab names from db")
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func start(forGameType : GameType) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NameGameVC") as! NameGameViewController
        vc.setGameGenerator(with: NameGame(), forGameType: forGameType, scoreData: ScoreData())
        present(vc, animated: true)
    }
}

extension HomeScreenViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppConstants.gameChoicesDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.gameCellIdentifier, for: indexPath) as! HomeScreenTableViewCell
        let game = AppConstants.gameChoicesDict[indexPath.row]
        
        cell.gameNameLabel.text = "\(game?.title ?? "No Title Available") - \(game?.description ?? "No Description Available")"
        cell.gameImage.image = game?.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // grab item chosen and start game.
        print("Tapped")
        switch indexPath.row {
        case 1:
            start(forGameType: .matt)
        case 2:
            start(forGameType: .teams)
        default:
            start(forGameType: .normal)
        }
    }
    
}
