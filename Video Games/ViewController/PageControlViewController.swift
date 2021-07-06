//
//  PageControlViewController.swift
//  Video Games
//
//  Created by Arda ILGILI on 1.07.2021.
//

import UIKit

class PageControlViewController: UIViewController {
    
    var gameImage: UIImageView!
    var gameIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameImage = UIImageView()
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        gameImage.isUserInteractionEnabled = true
        
        view.addSubview(gameImage)
        
        NSLayoutConstraint.activate([
            gameImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            gameImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
            ])

    }

}


