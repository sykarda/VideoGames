//
//  FavViewController.swift
//  Video Games
//
//  Created by Arda ILGILI on 3.07.2021.
//

import UIKit
import Alamofire
import SDWebImage

class FavViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private var gamesCollection: UICollectionView!
    private let cellReuseIdentifier = "collectionCell"
    private var gameArray = [GameDetail]()
    private var favArray = [Int]()
    private let defaults = UserDefaults.standard
    private var gameDetailView: GameDetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        
        gamesCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        gamesCollection.delegate = self
        gamesCollection.dataSource = self
        gamesCollection.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        gamesCollection.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(gamesCollection)
        
        NSLayoutConstraint.activate([
            gamesCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gamesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            gamesCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            gamesCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.gameDetailView = nil
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        favArray = defaults.object(forKey: "FavGameSet") as? Array<Int> ?? [Int]()
        favArray.sort()
        self.fetchGames(favArray) { (array) in
            self.gameArray = array
            self.gamesCollection.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? GameCollectionViewCell else {
            fatalError("Unable to dequeue cell")
        }
        
        let gameDetail = gameArray[indexPath.item]
        
        cell.nameLabel.text = gameDetail.name
        cell.ratingLabel.text = "\(gameDetail.rating) - "
        cell.releasedLabel.text = gameDetail.released
        cell.gameImage.sd_setImage(with: URL(string: gameDetail.background_image), completed: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var gameDetail: GameDetail!
        
        gameDetail = gameArray[indexPath.item]
        
        GameAPI.sharedInstance.fetchGameImage(imageURL: gameDetail.background_image) { (gameImage) in
            if gameImage != nil && self.gameDetailView == nil {
                let gameDetailView = GameDetailViewController()
                self.gameDetailView = gameDetailView
                
                gameDetailView.gameImage = gameImage
                gameDetailView.gameDetailText = gameDetail!.description
                gameDetailView.gameId = gameDetail!.id
                gameDetailView.gameName = gameDetail!.name
                gameDetailView.gameReleased = gameDetail!.released
                gameDetailView.gameMetaRev = "\(gameDetail!.rating)"

                self.navigationController?.pushViewController(gameDetailView, animated: true)
            }
        }
    }
    
    func fetchGames(_ gameIdArray: [Int], handler: @escaping ([GameDetail]) -> Void) {
        
        var gameDetailArray = [GameDetail]()
        
        for item in gameIdArray {
            
            GameAPI.sharedInstance.fetchGameDetail(gameId: item) { (gameDetail) in
                if let gameDetailFinal = gameDetail {
                    gameDetailArray.append(gameDetailFinal)
                    if gameDetailArray.count == gameIdArray.count {
                        gameDetailArray.sort(by: {$0.id > $1.id})
                        handler(gameDetailArray)
                    }
                }
            }
        }
    }
}
