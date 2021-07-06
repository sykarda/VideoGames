//
//  GameCollectionViewCell.swift
//  Video Games
//
//  Created by Arda ILGILI on 30.06.2021.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    let gameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let releasedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        backgroundColor = UIColor.black
        
        addSubview(gameImage)
        addSubview(nameLabel)
        addSubview(ratingLabel)
        addSubview(releasedLabel)
        
        gameImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        gameImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        gameImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        gameImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: gameImage.rightAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: gameImage.topAnchor).isActive = true
        
        ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        ratingLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        
        releasedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        releasedLabel.leftAnchor.constraint(equalTo: ratingLabel.rightAnchor).isActive = true

        }
}
