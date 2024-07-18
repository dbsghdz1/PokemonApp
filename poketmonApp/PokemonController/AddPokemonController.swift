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
  
  private func fetchData<T: Decodable>(url: URL,
                                       completion: @escaping (Result<T, AFError>) -> Void) {
    AF.request(url).responseDecodable(of: T.self) { response in
      completion(response.result)
    }
  }
  
  private func fetchCurrentData() {
    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...1000))") else {
      print("Invalid URL")
      return
    }
    
    fetchData(url: url) { (result: Result<PokemonData, AFError>) in
      switch result {
      case .success(let data):
        if let imageUrl = URL(string: data.sprites.frontDefault) {
          self.loadImage(from: imageUrl)
        }
      case .failure(_):
        print("Failed to fetch data")
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
        }
      case .failure(_):
        print("Failed to load image")
      }
    }
  }
  
  private func saveContext() {
    do {
      try PokemonListController.context.save()
      print("Data saved successfully")
    } catch {
      print("Failed to save data")
    }
  }
  
  func createNewCell(name: String, phoneNumber: String, image: Data) {
    let newPhoneBook = PhoneBook(context: PokemonListController.context)
    newPhoneBook.name = name
    newPhoneBook.phoneNumber = phoneNumber
    newPhoneBook.pokemonImage = image
    saveContext()
  }
  
  func updateData(name: String, updateName: String, updatePhoneNumber: String, updateImage: Data) {
    let fetchRequest: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    
    do {
      let phoneBooks = try PokemonListController.context.fetch(fetchRequest)
      for phoneBook in phoneBooks {
        phoneBook.name = updateName
        phoneBook.phoneNumber = updatePhoneNumber
        phoneBook.pokemonImage = updateImage
        try PokemonListController.context.save()
      }
    } catch {
      print("Failed to update data")
    }
  }
  
  @objc
  func applyButtonTapped() {
    guard let phoneNumber = addPokemonView.phoneNumberTextView.text,
          let phoneName = addPokemonView.nameTextView.text,
          let image = addPokemonView.randomImage.image?.pngData() else { return }
    
    if checkPage == true {
      createNewCell(name: phoneName, phoneNumber: phoneNumber, image: image)
    } else {
      if let pokemonName = pokemonName {
        updateData(name: pokemonName, updateName: phoneName, updatePhoneNumber: phoneNumber, updateImage: image)
      }
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc
  func createRandom() {
    fetchCurrentData()
  }
}
