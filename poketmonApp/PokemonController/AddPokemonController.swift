//
//  AddPokemonController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//
// <Back 버튼 customButton

import UIKit

import Alamofire

class AddPokemonController: UIViewController {
  
  let urlQueryItems: [URLQueryItem] = [
    URLQueryItem(name: "id", value: "25"),
    URLQueryItem(name: "name", value: "pikachu"),
    URLQueryItem(name: "height", value: "4"),
    URLQueryItem(name: "weight", value: "60")
  ]
  
  struct PokemonData: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    
    struct Sprites: Decodable {
      let front_default: String
    }
  }
  
  var addPokemonView: AddPokemonView!
  
  override func loadView() {
    super.loadView()
    addPokemonView = AddPokemonView(frame: self.view.frame)
    self.view = addPokemonView
    self.title = "연락처 추가"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    fetchCurrentData()
  }
  
  //서버 데이터 불러오기
  private func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
    AF.request(url).responseDecodable(of: T.self) { response in
      completion(response.result)
    }
  }
  
  private func fetchCurrentData() {
    var urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/25")
    urlComponents?.queryItems = self.urlQueryItems
    
    guard let url = urlComponents?.url else {
      print("url이상함")
      return
    }
    
    fetchData(url: url) { (result: Result<PokemonData, AFError>) in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          if let imageUrl = URL(string: data.sprites.front_default) {
            self.loadImage(from: imageUrl)
          }
        }
      case .failure(_):
        print("fail")
      }
    }
  }
  
  private func loadImage(from url: URL) {
    AF.request(url).responseData { response in
      switch response.result {
      case .success(let data):
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self.addPokemonView.randomImage.image = image
          }
        } else {
          print("Failed to convert data to image")
        }
      case .failure(let error):
        print("Failed to load image: \(error)")
      }
    }
  }
  
  @objc
  func backButtonTapped() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc
  func applyButtonTapped() {
    self.navigationController?.popViewController(animated: true)
  }
}
