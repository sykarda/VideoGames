//
//  TabViewController.swift
//  Video Games
//
//  Created by Arda ILGILI on 30.06.2021.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let listTab = GameListViewController()
        let favouriteTab = FavViewController()
        
        let gameListNavigation = UINavigationController(rootViewController: listTab)
        gameListNavigation.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "house.fill"), selectedImage: nil)
        
        let favNavigation = UINavigationController(rootViewController: favouriteTab)
        favNavigation.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "star.fill"), selectedImage: nil)
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        let controllers = [gameListNavigation, favNavigation]
        self.viewControllers = controllers
    }

}
