//
//  AddPokemonController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.

import UIKit

class AddPokemonController: UIViewController {

  let fetchNetWork = NetworkManager.shared
  let contatckCoreData = CoreDataManager.shared
  var receivedStrings: [String]?
  var receivedImage: Data?
  var addPokemonView = AddPokemonView(frame: .zero)
  
  override func loadView() {
    addPokemonView = AddPokemonView(frame: UIScreen.main.bounds)
    self.view = addPokemonView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewData()
    view.backgroundColor = .systemBackground
    self.title = "연락처 추가"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(applyButtonTapped))
    self.addPokemonView.createRandomImage.addTarget(self,
                                                    action: #selector(createRandom),
                                                    for: .touchUpInside)
  }

  
  private func setupViewData() {
    if let receivedImage = receivedImage {
      addPokemonView.randomImage.image = UIImage(data: receivedImage)
      addPokemonView.nameTextView.text = receivedStrings?[0]
      addPokemonView.phoneNumberTextView.text = receivedStrings?[1]
      self.title = receivedStrings?[0]
    }
  }
  
  @objc
  func applyButtonTapped() {
    guard let phoneNumber = addPokemonView.phoneNumberTextView.text,
          let phoneName = addPokemonView.nameTextView.text,
          let image = addPokemonView.randomImage.image?.pngData() else { return }
    
      if let pokemonName = receivedStrings?[0] {
        contatckCoreData.updateData(name: pokemonName, updateName: phoneName, updatePhoneNumber: phoneNumber, updateImage: image)
      } else {
        contatckCoreData.createNewCell(name: phoneName, phoneNumber: phoneNumber, image: image)
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
