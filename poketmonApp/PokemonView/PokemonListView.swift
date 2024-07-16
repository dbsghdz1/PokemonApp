//
//  PokeomListView.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//

import UIKit

import SnapKit

class PokemonListView: UIView {
  
  let pokemonList = UITableView()
  
  lazy var addButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.tintColor = .gray
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func configureUI() {
    self.addSubview(pokemonList)
  }
  
  func setConstraints() {
    pokemonList.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(150)
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().inset(30)
    }
  }
}
