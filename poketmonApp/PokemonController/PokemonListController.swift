//
//  ViewController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//

import UIKit
import CoreData

class PokemonListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var pokemonListView: PokemonListView!
  var container: NSPersistentContainer!
  
  override func loadView() {
    super.loadView()
    pokemonListView = PokemonListView(frame: self.view.frame)
    self.view = pokemonListView
    self.title = "친구 목록"
    self.navigationItem.backButtonTitle = "Back"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpTableView()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    self.container = appDelegate.persistentContainer
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    print("apperaring")
    print(UserData.phoneBook.count)
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
    pokemonListView.pokemonList.register(PokemonListCell.self, forCellReuseIdentifier: PokemonListCell.identifier)
    pokemonListView.pokemonList.rowHeight = 80
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return UserData.phoneBook.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.identifier, for: indexPath) as? PokemonListCell else { return UITableViewCell() }
    let name = UserData.phoneBook.keys.sorted()
    let image = UserData.imageArray.keys.sorted()
    cell.pokemonView.image = UserData.imageArray[image[indexPath.row]]
    cell.nameLabel.text = name[indexPath.row]
    cell.phoneNumberLabel.text = UserData.phoneBook[name[indexPath.row]]
    return cell
  }
  
  func readAllData() {
    do {
      let phoneBooks = try self.container.viewContext.fetch(PhoneBook.fetchRequest())
      
      for phoneBook in phoneBooks as [NSManagedObject] {
        if let name = phoneBook.value(forKey: PhoneBook.Key.name) as? String,
           let phoneNumber = phoneBook.value(forKey: PhoneBook.Key.phoneNumber) {
          UserData.phoneBook[name] = phoneNumber as? String
        }
      }
    } catch {
      print("읽기 실패")
    }
  }
}

