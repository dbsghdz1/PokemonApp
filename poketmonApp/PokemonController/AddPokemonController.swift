//
//  AddPokemonController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
// 1.콜백 패턴 적용? 일대다 관계에서 효과적이라는데....

import UIKit
import CoreData
import Alamofire

class AddPokemonController: UIViewController {
  
  static func makeFactoryPattern() -> AddPokemonController {
    return AddPokemonController()
  }
  
  let fetchNetWork = NetworkManager.shared
  let contatckCoreData = CoreDataManager.shared
  var navigationTitle: String?
  var pokemonName: String?
  var pokemonNumber: String?
  var checkPage: Bool? = true
  var pokemonImage: Data?
  var addPokemonView: AddPokemonView!
  
  override func loadView() {
    addPokemonView = AddPokemonView(frame: UIScreen.main.bounds)
    self.view = addPokemonView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupViewData()
    self.title = "연락처 추가"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(applyButtonTapped))
    self.addPokemonView.createRandomImage.addTarget(self,
                                                    action: #selector(createRandom),
                                                    for: .touchUpInside)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if checkPage == true {
      createRandom()
    }
  }
  
  private func setupViewData() {
    if let navigationTitle = navigationTitle,
       let pokemonName = pokemonName,
       let pokemonNumber = pokemonNumber,
       let pokemonImage = pokemonImage {
      addPokemonView.nameTextView.text = pokemonName
      addPokemonView.phoneNumberTextView.text = pokemonNumber
      addPokemonView.randomImage.image = UIImage(data: pokemonImage)
      self.title = navigationTitle
    }
  }
  
  @objc
  func applyButtonTapped() {
    guard let phoneNumber = addPokemonView.phoneNumberTextView.text,
          let phoneName = addPokemonView.nameTextView.text,
          let image = addPokemonView.randomImage.image?.pngData() else { return }
    
    if checkPage == true {
      contatckCoreData.createNewCell(name: phoneName, phoneNumber: phoneNumber, image: image)
    } else {
      if let pokemonName = pokemonName {
        contatckCoreData.updateData(name: pokemonName, updateName: phoneName, updatePhoneNumber: phoneNumber, updateImage: image)
      }
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc
  func createRandom() {
    NetworkManager.shared.fetchCurrentData { result in
      switch result {
      case .success(let pokemonData):
        if let imageUrl = URL(string: pokemonData.sprites.frontDefault) {
          NetworkManager.shared.loadImage(from: imageUrl) { imageResult in
            switch imageResult {
            case .success(let image):
              DispatchQueue.main.async {
                self.addPokemonView.randomImage.image = image
              }
            case .failure(let error):
              print("Failed to load image: \(error)")
            }
          }
        }
      case .failure(let error):
        print("Failed to fetch data: \(error)")
      }
    }
  }
}
