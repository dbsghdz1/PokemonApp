//
//  PokemonListCell.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//cell identifier class명

import UIKit

import SnapKit

class PokemonListCell: UITableViewCell {
  static let identifier = "cell"
  
  lazy var pokemonView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 30
    imageView.layer.borderWidth = 1.0
    imageView.layer.borderColor = UIColor.gray.cgColor
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.text = "name"
    return label
  }()
  
  lazy var phoneNumberLabel: UILabel = {
    let label = UILabel()
    label.text = "010-0000-0000"
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureUI() {
    [
      pokemonView,
      nameLabel,
      phoneNumberLabel
    ].forEach { contentView.addSubview($0) }
  }
  
  func setConstraints() {
    pokemonView.snp.makeConstraints { make in
      make.width.height.equalTo(60)
      make.top.equalToSuperview().inset(10)
      make.leading.equalToSuperview().inset(30)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.leading.equalTo(pokemonView.snp.trailing).offset(20)
      make.centerY.equalTo(pokemonView)
    }
    
    phoneNumberLabel.snp.makeConstraints { make in
      make.centerY.equalTo(pokemonView)
      make.leading.equalTo(nameLabel.snp.trailing).offset(50)
    }
  }
}
