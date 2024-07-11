//
//  ViewController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//

import UIKit

class PokemonListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var pokemonListView: PokemonListView!
  
  override func loadView() {
    super.loadView()
    pokemonListView = PokemonListView(frame: self.view.frame)
    self.view = pokemonListView
    self.title = "친구 목록"
    self.navigationItem.rightBarButtonItem = pokemonListView.addButton
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpTableView()
  }
  
  func setUpTableView() {
    pokemonListView.pokemonList.delegate = self
    pokemonListView.pokemonList.dataSource = self
    pokemonListView.pokemonList.register(PokemonListCell.self, forCellReuseIdentifier: PokemonListCell.identifier)
    pokemonListView.pokemonList.rowHeight = 80
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.identifier, for: indexPath) as? PokemonListCell else { return UITableViewCell() }
    return cell
  }
}

