//
//  Games.swift
//  Video Games
//
//  Created by Arda ILGILI on 1.07.2021.
//

import Foundation

struct Games: Codable {
  let count: Int
  let all: [Game]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}
