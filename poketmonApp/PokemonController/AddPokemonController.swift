//
//  AddPokemonController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//
// factory Pattern

import UIKit
import CoreData

import Alamofire

class AddPokemonController: UIViewController {
  
  static func makeFactoryPattern() -> AddPokemonController {
    let viewController = AddPokemonController()
    return viewController
  }
  
  var container: NSPersistentContainer!
  var navigationTitle: String?
  var pokemonName: String?
  var pokemonNumber: String?
  var checkPage: Bool? = true
  
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
    self.addPokemonView.createRandomImage.addTarget(self, action: #selector(createRandom), for: .touchUpInside)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let navigationTitle = navigationTitle,
       let pokemonName = pokemonName,
       let pokemonNumber = pokemonNumber {
      addPokemonView.nameTextView.text = pokemonName
      addPokemonView.phoneNumberTextView.text = pokemonNumber
      self.title = navigationTitle
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    self.container = appDelegate.persistentContainer
    fetchCurrentData(3)
  }
  
  //서버 데이터 불러오기
  private func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
    AF.request(url).responseDecodable(of: T.self) { response in
      completion(response.result)
    }
  }
  
  private func fetchCurrentData(_ random: Int) {
    var urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(random)")
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
        print(#function)
        print("실패")
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
        print("이미지 가져오기실패")
      }
    }
  }
  
  func createNewCell(name: String, phoneNumber: String) {
    guard let entity = NSEntityDescription.entity(forEntityName: PhoneBook.className, in: self.container.viewContext) else { return }
    let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
    newPhoneBook.setValue(name, forKey: PhoneBook.Key.name)
    newPhoneBook.setValue(phoneNumber, forKey: PhoneBook.Key.phoneNumber)
    
    do {
      try self.container.viewContext.save()
      print("")
    } catch {
      print("")
    }
  }
  
  func updateData(name: String, updateName: String) {
    let fetchRequest = PhoneBook.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    
    do {
      let phoneBooks = try self.container.viewContext.fetch(fetchRequest)
      for phoneBook in phoneBooks as [NSManagedObject] {
        phoneBook.setValue(updateName, forKey: PhoneBook.Key.name)
        try self.container.viewContext.save()
      }
    } catch {
      print("수정실패")
    }
  }
  
  @objc
  func backButtonTapped() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc
  func applyButtonTapped() {
    if let checkPage = checkPage {
      print(checkPage)
      if checkPage {
        self.navigationController?.popViewController(animated: true)
        if let phoneNumber = addPokemonView.phoneNumberTextView.text,
           let phoneName = addPokemonView.nameTextView.text {
          createNewCell(name: phoneName, phoneNumber: phoneNumber)
          UserData.phoneBook[phoneName] = phoneNumber
          UserData.imageArray[phoneName] = addPokemonView.randomImage.image
        }
      } else {
        if let phoneNumber = addPokemonView.phoneNumberTextView.text,
           let phoneName = addPokemonView.nameTextView.text,
           let pokemonName = pokemonName,
           let pokemonNumber = pokemonNumber {
          updateData(name: pokemonName, updateName: phoneName)
          updateData(name: pokemonNumber, updateName: phoneNumber)
          UserData.phoneBook[phoneName] = phoneNumber
          UserData.phoneBook.removeValue(forKey: pokemonName)
          UserData.imageArray[phoneName] = addPokemonView.randomImage.image
          self.navigationController?.popViewController(animated: true)
        }
      }
    }
  }
  
  @objc
  func createRandom() {
    let randomNumber = Int.random(in: 1...1000)
    fetchCurrentData(randomNumber)
  }
}
