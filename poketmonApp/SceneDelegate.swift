//
//  SceneDelegate.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = scene as? UIWindowScene else { return }
    
    let firstVC = PokemonListController()
    firstVC.onNext = { strings, image  in
      let secondVC = AddPokemonController()
      secondVC.receivedStrings = strings
      secondVC.receivedImage = image
      firstVC.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    let navigationController = UINavigationController(rootViewController: firstVC)
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }
}

