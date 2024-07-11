//
//  AddPokemonController.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//
// <Back 버튼 customButton

import UIKit

class AddPokemonController: UIViewController {
  
  var addPokemonView: AddPokemonView!
  
  override func loadView() {
    super.loadView()
    addPokemonView = AddPokemonView(frame: self.view.frame)
    self.view = addPokemonView
    self.title = "연락처 추가"
    if let backImage = UIImage(named: "chevron.backward") {
      let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
      self.navigationItem.leftBarButtonItem = backButton
    }
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
  }
  
  @objc
  func backButtonTapped() {
    
  }
  
  @objc
  func applyButtonTapped() {
    
  }
}
