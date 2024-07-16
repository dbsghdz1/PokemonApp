import UIKit
import CoreData
import Alamofire

class AddPokemonController: UIViewController {
  
  let fetchRequest: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
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
    addPokemonView = AddPokemonView(frame: UIScreen.main.bounds)
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
    fetchCurrentData(3)
  }
  
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
  
  func createNewCell(name: String, phoneNumber: String, image: Data) {
    container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    guard let entity = NSEntityDescription.entity(forEntityName: "PhoneBook", in: self.container.viewContext) else { return }
    let newPhoneBook = PhoneBook(entity: entity, insertInto: self.container.viewContext)
    newPhoneBook.name = name
    newPhoneBook.phoneNumber = phoneNumber
    newPhoneBook.pokemonImage = image
    
    do {
      try self.container.viewContext.save()
      print("Data saved successfully")
    } catch {
      print("Failed to save data")
    }
  }
  
  func updateData(name: String, updateName: String) {
    let fetchRequest = PhoneBook.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    do {
      let phoneBooks = try self.container.viewContext.fetch(fetchRequest)
      for phoneBook in phoneBooks {
        phoneBook.name = updateName
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
      if checkPage {
        self.navigationController?.popViewController(animated: true)
        if let phoneNumber = addPokemonView.phoneNumberTextView.text,
           let phoneName = addPokemonView.nameTextView.text,
           let image = addPokemonView.randomImage.image?.pngData() {
          createNewCell(name: phoneName, phoneNumber: phoneNumber, image: image)
        }
      } else {
        if let phoneNumber = addPokemonView.phoneNumberTextView.text,
           let phoneName = addPokemonView.nameTextView.text,
           let pokemonName = pokemonName,
           let pokemonNumber = pokemonNumber {
          updateData(name: pokemonName, updateName: phoneName)
          updateData(name: pokemonNumber, updateName: phoneNumber)
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
