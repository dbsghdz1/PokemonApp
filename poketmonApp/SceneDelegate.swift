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
    
    let firstViewController = PokemonListController()
    firstViewController.onNext = { strings, image  in
      let secondViewController = AddPokemonController()
      secondViewController.receivedStrings = strings
      secondViewController.receivedImage = image
      firstViewController.navigationController?.pushViewController(secondViewController,
                                                                   animated: true)
    }
    
    let navigationController = UINavigationController(rootViewController: firstViewController)
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }
}

