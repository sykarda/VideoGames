//
//  GameAPI.swift
//  Video Games
//
//  Created by Arda ILGILI on 5.07.2021.
//

import Foundation
import Alamofire

class GameAPI: NSObject {
    
    static let sharedInstance = GameAPI()
    
    func fetchGames(page: Int, handler: @escaping (Games?) -> Void) {
        AF.request("https://api.rawg.io/api/games?page=\(page)&key=b24419ececa947c7a7e8d78c85b9413d").responseDecodable(of: Games.self) { (response) in
            guard let games = response.value else {
                return
            }
            handler(games)
        }
    }
    
    func fetchGameDetail(gameId: Int, handler: @escaping (GameDetail?) -> Void) {
        AF.request("https://api.rawg.io/api/games/\(gameId)?key=b24419ececa947c7a7e8d78c85b9413d").responseDecodable(of: GameDetail.self) { (response) in
            switch response.result {
            case .success(let responseData):
                handler(responseData)
            case .failure( _):
                handler(nil)
            }
        }
    }
    
    func fetchGameImage(imageURL: String, handler: @escaping (UIImage?) -> Void) {
        AF.request( imageURL, method: .get).response { (response) in
         switch response.result {
          case .success(let responseData):
            handler(UIImage(data: responseData!, scale:1))
         case .failure( _):
            handler(nil)
          }
        }
    }
}
