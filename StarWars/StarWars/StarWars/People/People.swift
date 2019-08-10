//
//  People.swift
//  StarWars
//
//  Created by Alex Paul on 8/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct PeopleSearch: Codable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [People]
}

struct People: Codable {
  let name: String
  let height: String
  let mass: String
  let hairColor: String
  let skinColor: String
  let birthYear: String
  let gender: String
  let homeworld: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case height
    case mass
    case hairColor = "hair_color"
    case skinColor = "skin_color"
    case birthYear = "birth_year"
    case gender
    case homeworld
  }
}
