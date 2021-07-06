//
//  GameDetail.swift
//  Video Games
//
//  Created by Arda ILGILI on 2.07.2021.
//

import Foundation

struct GameDetail: Codable {
    
    let id: Int
    let name: String
    let description: String
    let released: String
    let rating: Double
    let background_image: String

}
