//
//  PokemonListController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//
//

import UIKit
import CoreData

class PokemonListController: UIViewController {
  
  var pokemonListView: PokemonListView!
  static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var models: [PhoneBook] = [] {
    didSet {
      pokemonListView.pokemonList.reloadData()
    }
  }
  
  override func loadView() {
    pokemonListView = PokemonListView(frame: UIScreen.main.bounds)
    self.view = pokemonListView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.title = "친구 목록"
    self.navigationItem.backButtonTitle = "Back"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(addButtonTapped))
    setUpTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    models = CoreDataManager.shared.readAllData()
  }
  
  @objc
  func addButtonTapped() {
    let viewController = AddPokemonController.makeFactoryPattern()
    viewController.checkPage = true
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  func setUpTableView() {
    pokemonListView.pokemonList.delegate = self
    pokemonListView.pokemonList.dataSource = self
    pokemonListView.pokemonList.register(PokemonListCell.self,
                                         forCellReuseIdentifier: PokemonListCell.identifier)
    pokemonListView.pokemonList.rowHeight = 80
  }
}

extension PokemonListController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.identifier,
                                                   for: indexPath) as? PokemonListCell
    else { return UITableViewCell() }
    let phoneBook = models[indexPath.row]
    cell.nameLabel.text = phoneBook.name
    cell.phoneNumberLabel.text = phoneBook.phoneNumber
    if let data = phoneBook.pokemonImage,
       let image = UIImage(data: data) {
      cell.pokemonView.image = image
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let viewController = AddPokemonController.makeFactoryPattern()
    let phoneBook = models[indexPath.row]
    viewController.navigationTitle = phoneBook.name
    viewController.pokemonName = phoneBook.name
    viewController.pokemonNumber = phoneBook.phoneNumber
    viewController.pokemonImage = phoneBook.pokemonImage
    viewController.checkPage = false
    navigationController?.pushViewController(viewController, animated: true)
  }
}
