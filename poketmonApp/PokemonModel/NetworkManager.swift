//
//  DataManager.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/18/24.
//

import UIKit
import Alamofire

class NetworkManager {
  static let shared = NetworkManager()
  
  private init() {}
  
  func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
    AF.request(url).responseDecodable(of: T.self) { response in
      completion(response.result)
    }
  }
  
  func fetchCurrentData(completion: @escaping (Result<PokemonData, AFError>) -> Void) {
    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...1000))") else {
      print("URL 이상함")
      return
    }
    
    fetchData(url: url, completion: completion)
  }
  
  func loadImage(from url: URL, completion: @escaping (Result<UIImage, AFError>) -> Void) {
    AF.request(url).responseData { response in
      switch response.result {
      case .success(let data):
        if let image = UIImage(data: data) {
          completion(.success(image))
        } else {
          completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
