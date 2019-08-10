//
//  NetworkError.swift
//  StarWars
//
//  Created by Alex Paul on 8/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  case badURL
  case badStatusCode
  case apiError(Error)
  case decodingError(Error)
}
