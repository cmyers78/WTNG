//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class FaceButton: UIButton {

    var id: Int = 0
    var tintView: UIView = UIView(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        setTitleColor(.black, for: .normal)
        titleLabel?.alpha = 1.0
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.text = "???"
        tintView.alpha = 0.0
        tintView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tintView)
        
        tintView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tintView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tintView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tintView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    // TODO: Show the user's face on the button.
    
    func getFaces() -> [UIImage] {
        var imageAray = [UIImage]()
        let namesData = NamesDataStore().getNamesData()
        for i in 0...5 {
            let user = namesData[i]
            if let imageString = user.headShotURL {
                if let imageURL = URL(string: imageString) {
                    let image = convertToImage(url: imageURL)
                        imageAray.append(image)
                }
            }
        }
        return imageAray
    }
    
    private func convertToImage(url : URL) -> UIImage{
        var imageFromURL = UIImage()
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageFromURL = image
                    }
                }
            }
        }
        return imageFromURL
    }
}
