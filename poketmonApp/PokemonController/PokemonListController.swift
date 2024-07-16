//
//  ViewController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//view controller에서 가장 중요한 건 AppLifeCycle

import UIKit
import CoreData

class PokemonListController: UIViewController {
  
  var pokemonListView: PokemonListView!
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var models = [PhoneBook()]
  let fetchRequest: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
  
  override func loadView() {
    pokemonListView = PokemonListView(frame: UIScreen.main.bounds)
    self.view = pokemonListView
    self.title = "친구 목록"
    self.navigationItem.backButtonTitle = "Back"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(addButtonTapped))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpTableView()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    readAllData()
    pokemonListView.pokemonList.reloadData()
  }
  
  @objc
  func addButtonTapped() {
    self.navigationController?.pushViewController(AddPokemonController(), animated: true)
  }
  
  func setUpTableView() {
    pokemonListView.pokemonList.delegate = self
    pokemonListView.pokemonList.dataSource = self
    pokemonListView.pokemonList.register(PokemonListCell.self,
                                         forCellReuseIdentifier: PokemonListCell.identifier)
    pokemonListView.pokemonList.rowHeight = 80
  }
  
  func readAllData() {
    do {
      models = try context.fetch(PhoneBook.fetchRequest())
      DispatchQueue.main.async {
        self.pokemonListView.pokemonList.reloadData()
      }
    } catch {
      print("읽기 실패")
    }
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
    let sortedModels = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortedModels]
    do {
      let phoneBooks = try context.fetch(fetchRequest)
      let phoneBook = phoneBooks[indexPath.row]
      cell.nameLabel.text = phoneBook.name
      cell.nameLabel.text = phoneBook.name
      cell.phoneNumberLabel.text = phoneBook.phoneNumber
      if let data = phoneBook.pokemonImage,
         let image = UIImage(data: data) {
        cell.pokemonView.image = image
      }
      
    } catch {
      print("fail")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let viewController = AddPokemonController.makeFactoryPattern()
    let phoneBook = models[indexPath.row]
    viewController.navigationTitle = phoneBook.name
    viewController.pokemonName = phoneBook.name
    viewController.pokemonNumber = phoneBook.phoneNumber
    viewController.checkPage = false
    navigationController?.pushViewController(viewController, animated: true)
    //Factory 패턴
  }
}
