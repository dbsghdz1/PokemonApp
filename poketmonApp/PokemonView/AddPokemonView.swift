//
//  AddPokemonView.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//

import UIKit

import SnapKit

class AddPokemonView: UIView {
  
  lazy var randomImage: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 100
    imageView.layer.borderWidth = 1.0
    imageView.layer.borderColor = UIColor.gray.cgColor
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()
  
  lazy var createRandomImage: UIButton = {
    let button = UIButton()
    button.setTitle("랜덤 이미지 생성", for: .normal)
    button.setTitleColor(UIColor.gray, for: .normal)
    return button
  }()
  
  lazy var nameTextView: UITextView = {
    let textView = UITextView()
    textView.layer.cornerRadius = 3
    textView.layer.borderWidth = 1
    textView.font = .boldSystemFont(ofSize: 30)
    textView.layer.borderColor = UIColor.gray.cgColor
    return textView
  }()
  
  lazy var phoneNumberTextView: UITextView = {
    let textView = UITextView()
    textView.layer.cornerRadius = 3
    textView.layer.borderWidth = 1
    textView.font = .boldSystemFont(ofSize: 30)
    textView.layer.borderColor = UIColor.gray.cgColor
    return textView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setconstraints()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureUI() {
    [
      randomImage,
      createRandomImage,
      nameTextView,
      phoneNumberTextView
    ].forEach { self.addSubview($0) }
  }
  
  func setconstraints() {
    randomImage.snp.makeConstraints { make in
      make.width.height.equalTo(200)
      make.top.equalToSuperview().inset(150)
      make.centerX.equalToSuperview()
    }
    
    createRandomImage.snp.makeConstraints { make in
      make.top.equalTo(randomImage.snp.bottom).offset(10)
      make.centerX.equalTo(randomImage)
    }
    
    nameTextView.snp.makeConstraints { make in
      make.top.equalTo(createRandomImage.snp.bottom).offset(10)
      make.leading.trailing.equalToSuperview().inset(10)
      make.height.equalTo(50)
    }
    
    phoneNumberTextView.snp.makeConstraints { make in
      make.top.equalTo(nameTextView.snp.bottom).offset(10)
      make.leading.trailing.equalToSuperview().inset(10)
      make.height.equalTo(50)
    }
  }
}
