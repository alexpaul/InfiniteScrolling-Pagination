//
//  StarWarsAPIClient.swift
//  StarWars
//
//  Created by Alex Paul on 8/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

final class StarWarsAPIClient {
  static func searchResource(method: String,
                           resource: Resource, 
                           page: String,
                           completion: @escaping (Result<Resource, NetworkError>, String?) -> Void) {
    let baseURL = "https://swapi.dev/api/"
    let endpointURL = "\(baseURL)\(method)?page=\(page)"
    guard let url = URL(string: endpointURL) else {
      completion(.failure(NetworkError.badURL), nil)
      return
    }
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard let httpResponse = (response as? HTTPURLResponse),
        (200...299).contains(httpResponse.statusCode) else {
        completion(.failure(NetworkError.badStatusCode), nil)
        return
      }
      if let error = error {
        completion(.failure(NetworkError.apiError(error)), nil)
      } else if let data = data {
        do {
          switch resource {
          case.people(_):
            let search = try JSONDecoder().decode(PeopleSearch.self, from: data)
            completion(.success(Resource.people(search.results)), search.next)
          case .planets:
            print()
          }
        } catch {
          completion(.failure(NetworkError.decodingError(error)), nil)
        }
      }
    }
    task.resume()
  }
}
