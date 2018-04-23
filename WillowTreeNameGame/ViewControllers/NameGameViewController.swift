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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        let firstData = NamesDataStore().returnNameDataAtIndex(0)
        configureFaces(from: firstData)
//
//        print(firstData.headShotURL)
//
//        let dataInfo = NamesDataStore().returnNameDataAtIndex(4)
//        guard let dataURLString = dataInfo.headShotURL else { return }
//        print(dataURLString)
//        print()
//
//        print("That was data url string")
//        guard let urlData = URL(string: firstData.headShotURL!) else { return }
//
//        let datum = try! Data(contentsOf: urlData)
//        let imagTest = UIImage(data: datum)
//
//        // This works
//        let url = URL(string: "http://images.ctfassets.net/3cttzl4i3k1h/3SQLIq0Y36oYyaiwCSwOY8/a65ae6620c8041b2773c1915156261d7/headshot_ben_frye.jpg")
//        let data = try! Data(contentsOf: url!)
//        let img = UIImage(data: data)
//        let btn = imageButtons[3]
//        btn.setImage(img, for: .normal)
//        btn.backgroundColor = .red
//        print(btn.currentImage)
        
        
//        for button in imageButtons {
//            button.setImage(img, for: .normal)
//            button.layer.borderWidth = 1.5
//        }
//
//        let btn4 = imageButtons[4]
//        btn4.setImage(imagTest, for: .normal)
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        print("Button Tapped")
        print(button.tag)
    }
    
    func configureFaces(from model : NamesDataModel) {
        guard let imageString = model.headShotURL else { return }
        for button in imageButtons {
            button.convertURLToImage(urlString: imageString) { image in
                button.setImage(image, for: .normal)
            }
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
