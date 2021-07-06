//
//  ViewController.swift
//  Video Games
//
//  Created by Arda ILGILI on 29.06.2021.
//

import UIKit
import Alamofire
import SDWebImage

class GameListViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var searchBox: UITextField!
    private var pageController: UIPageViewController!
    private var controllers = [UIViewController]()
    private var containerView: UIView!
    private var gamesCollection: UICollectionView!
    private let cellReuseIdentifier = "collectionCell"
    private var noGamesFoundLabel: UILabel!
    private var current_page = 1
    private var gameDetailView: GameDetailViewController!
    
    private var gameArray = [Game]()
    private var filteredGameArray = [Game]()
    
    private var gamesCollectionDefaultTopConstraint: NSLayoutConstraint!
    private var gamesCollectionNoPageControlTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.gray
        
        searchBox = UITextField()
        searchBox.font = UIFont.systemFont(ofSize: 15)
        searchBox.borderStyle = UITextField.BorderStyle.roundedRect
        searchBox.placeholder = "Search for a game"
        searchBox.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBox)
        searchBox.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                
        view.addConstraint(NSLayoutConstraint(item: searchBox!, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        searchBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        searchBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: searchBox.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
            containerView.heightAnchor.constraint(equalToConstant: 200.0),
            ])
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageController.dataSource = self
        pageController.delegate = self
        
        addChild(pageController)
        
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(pageController.view)
        
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            pageController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
            pageController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0),
            pageController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0),
            ])
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        
        gamesCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        gamesCollection.delegate = self
        gamesCollection.dataSource = self
        gamesCollection.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        gamesCollection.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(gamesCollection)
        
        gamesCollectionDefaultTopConstraint = NSLayoutConstraint(item: gamesCollection!, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 20)
        
        gamesCollectionNoPageControlTopConstraint = NSLayoutConstraint(item: gamesCollection!, attribute: .top, relatedBy: .equal, toItem: searchBox, attribute: .bottom, multiplier: 1, constant: 20)
        
        NSLayoutConstraint.activate([
            gamesCollectionDefaultTopConstraint,
            gamesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            gamesCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            gamesCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
            ])
        
        noGamesFoundLabel = UILabel()
        noGamesFoundLabel.text = "No games found!"
        noGamesFoundLabel.textColor = UIColor.label
        noGamesFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        noGamesFoundLabel.isHidden = true
        view.addSubview(noGamesFoundLabel)
        
        NSLayoutConstraint.activate([
            noGamesFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noGamesFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        fetchGames(page: current_page)
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.gameDetailView = nil
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text!.count >= 3 {
            self.containerView.isHidden = true
            
            let nameFilter = textField.text!
            
            filteredGameArray = gameArray.filter({$0.name.hasPrefix(nameFilter)})
            if filteredGameArray.count == 0 {
                gamesCollection.isHidden = true
                containerView.isHidden = true
                noGamesFoundLabel.isHidden = false
            } else {
                gamesCollection.isHidden = false
                containerView.isHidden = false
                noGamesFoundLabel.isHidden = true
            }
            gamesCollection.reloadData()
            
            NSLayoutConstraint.deactivate([gamesCollectionDefaultTopConstraint])
            NSLayoutConstraint.activate([gamesCollectionNoPageControlTopConstraint])
        } else {
            if filteredGameArray.count != 0 {
                self.containerView.isHidden = false
                filteredGameArray.removeAll()
                gamesCollection.reloadData()
                
                NSLayoutConstraint.deactivate([gamesCollectionNoPageControlTopConstraint])
                NSLayoutConstraint.activate([gamesCollectionDefaultTopConstraint])
            } else {
                self.containerView.isHidden = false
                self.gamesCollection.isHidden = false
                noGamesFoundLabel.isHidden = true
                
                NSLayoutConstraint.deactivate([gamesCollectionNoPageControlTopConstraint])
                NSLayoutConstraint.activate([gamesCollectionDefaultTopConstraint])
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredGameArray.count > 0 {
            return filteredGameArray.count
        } else {
            return gameArray.count - 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? GameCollectionViewCell else {
            fatalError("Unable to dequeue cell")
        }
        
        var game: Game!
        
        if filteredGameArray.count > 0 {
            game = filteredGameArray[indexPath.item]
        } else {
            game = gameArray[indexPath.item + 3]
        }
        
        cell.nameLabel.text = game.name
        cell.ratingLabel.text = "\(game.rating) - "
        cell.releasedLabel.text = game.released
        cell.gameImage.sd_setImage(with: URL(string: game.background_image), completed: nil)
        
        return cell
    }
    
    func showGameDetail(gameId: Int) {
        GameAPI.sharedInstance.fetchGameDetail(gameId: gameId) { (gameDetail) in
            if gameDetail != nil && self.gameDetailView == nil {
                
                let gameDetailView = GameDetailViewController()
                self.gameDetailView = gameDetailView
                
                GameAPI.sharedInstance.fetchGameImage(imageURL: gameDetail!.background_image) { (gameImage) in
                    if gameImage != nil {
                        gameDetailView.gameImage = gameImage
                        gameDetailView.gameDetailText = gameDetail!.description
                        gameDetailView.gameId = gameDetail!.id
                        gameDetailView.gameName = gameDetail!.name
                        gameDetailView.gameReleased = gameDetail!.released
                        gameDetailView.gameMetaRev = "\(gameDetail!.rating)"

                        self.navigationController?.pushViewController(gameDetailView, animated: true)
                        self.view.endEditing(true)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var game: Game!
        
        if filteredGameArray.count > 0 {
            game = filteredGameArray[indexPath.item]
        } else {
            game = gameArray[indexPath.item + 3]
        }
        
        showGameDetail(gameId: game.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == gameArray.count - 5 {
            DispatchQueue.main.async {
                 self.fetchGames(page: self.current_page)
             }
        }
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

    func randomColor() -> UIColor {
        return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
    }
    
    func fetchGames(page: Int) {
        
        GameAPI.sharedInstance.fetchGames(page: page) { (games) in
            if let gamesFinal = games?.all {
                for item in gamesFinal {
                    self.gameArray.append(item)
                }
                self.current_page += 1
                self.gamesCollection.reloadData()
                
                for index in 0..<3 {
                    let vc = PageControlViewController()
                    vc.view.backgroundColor = self.randomColor()
                    vc.gameIndex = index
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
                    vc.gameImage.addGestureRecognizer(tapGestureRecognizer)
                    
                    GameAPI.sharedInstance.fetchGameImage(imageURL: self.gameArray[index].background_image) { (image) in
                        if image != nil {
                            vc.gameImage.image = image
                        }
                    }
                    self.controllers.append(vc)
                }
                
                self.pageController.setViewControllers([self.controllers[0]], direction: .forward, animated: false)
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        guard let pageController = tappedImage.superview?.next as? PageControlViewController else {return}
        
        showGameDetail(gameId: gameArray[pageController.gameIndex].id)
    }
}

