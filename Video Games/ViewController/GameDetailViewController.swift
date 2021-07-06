//
//  GameDetailViewController.swift
//  Video Games
//
//  Created by Arda ILGILI on 1.07.2021.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    private var gameImageView: UIImageView!
    var gameImage: UIImage!
    
    private var gameNameLabel: UILabel!
    var gameName: String!
    
    private var gameReleaseLabel: UILabel!
    var gameReleased: String!
    
    private var gameMetaRevLabel: UILabel!
    var gameMetaRev: String!
    
    private var gameDetailTextView: UITextView!
    var gameDetailText: String!
    
    var gameId: Int!
    
    private var favButton: UIButton!    
    private var favGameSet = Set<Int>()
    private var faved: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        gameImageView = UIImageView()
        gameImageView.image = gameImage
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        
        favButton = UIButton(type: .system)
        favButton.tintColor = UIColor.white
        favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        favButton.translatesAutoresizingMaskIntoConstraints = false
        
        gameNameLabel = UILabel()
        gameNameLabel.text = gameName
        gameNameLabel.textColor = UIColor.black
        gameNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameReleaseLabel = UILabel()
        gameReleaseLabel.text = gameReleased
        gameReleaseLabel.textColor = UIColor.black
        gameReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameMetaRevLabel = UILabel()
        gameMetaRevLabel.text = gameMetaRev
        gameMetaRevLabel.textColor = UIColor.black
        gameMetaRevLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameDetailTextView = UITextView()
        gameDetailTextView.backgroundColor = UIColor.white
        gameDetailTextView.attributedText = gameDetailText.htmlToAttributedString
        gameDetailTextView.translatesAutoresizingMaskIntoConstraints = false
        gameDetailTextView.isEditable = false
        
        view.addSubview(gameImageView)
        view.addSubview(gameDetailTextView)
        view.addSubview(favButton)
        view.addSubview(gameNameLabel)
        view.addSubview(gameReleaseLabel)
        view.addSubview(gameMetaRevLabel)
        
        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            gameImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            
            gameNameLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 5),
            gameNameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            
            gameReleaseLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 5),
            gameReleaseLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            
            gameMetaRevLabel.topAnchor.constraint(equalTo: gameReleaseLabel.bottomAnchor, constant: 5),
            gameMetaRevLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            
            gameDetailTextView.topAnchor.constraint(equalTo: gameMetaRevLabel.bottomAnchor, constant: 1),
            gameDetailTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            gameDetailTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        view.addConstraint(NSLayoutConstraint(item: favButton!, attribute: .bottom, relatedBy: .equal, toItem: gameImageView, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: favButton!, attribute: .right, relatedBy: .equal, toItem: gameImageView, attribute: .right, multiplier: 1, constant: 0))
        
        let defaults = UserDefaults.standard
        let arrayFromUserDefaults = defaults.object(forKey: "FavGameSet") as? Array<Int> ?? Array<Int>()
        favGameSet = Set(arrayFromUserDefaults)
        if favGameSet.contains(gameId) {
            faved = true
            favButton.setImage(UIImage(named: "star-yellow-48.png"), for: .normal)
        } else {
            faved = false
            favButton.setImage(UIImage(named: "star-empty-50.png"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func favButtonTapped() {
        let defaults = UserDefaults.standard
        
        if faved {
            favButton.setImage(UIImage(named: "star-empty-50.png"), for: .normal)
            faved.toggle()
            favGameSet.remove(gameId)
        } else {
            favButton.setImage(UIImage(named: "star-yellow-48.png"), for: .normal)
            faved.toggle()
            favGameSet.insert(gameId)
        }
        
        let arrayToSave = Array(favGameSet)
        
        defaults.set(arrayToSave, forKey: "FavGameSet")
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
