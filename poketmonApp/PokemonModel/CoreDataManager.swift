//
//  DataManager.swift
//  poketmonApp
//
//  Created by 김윤홍 on 7/18/24.
//

import UIKit
import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()
  
  private init() {}
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
//  func saveContext() {
//    do {
//      try PokemonListController.context.save()
//      print("Data saved successfully")
//    } catch {
//      print("Failed to save data")
//    }
//  }
  //의심
  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        fatalError(#function)
      }
    }
  }
  
  func createNewCell(name: String, phoneNumber: String, image: Data) {
    let newPhoneBook = PhoneBook(context: context)
    newPhoneBook.name = name
    newPhoneBook.phoneNumber = phoneNumber
    newPhoneBook.pokemonImage = image
    saveContext()
  }
  
  func readAllData() -> [PhoneBook] {
    let fetchRequest: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    do {
      let phoneBooks = try context.fetch(fetchRequest)
      return phoneBooks
    } catch {
      print(#function)
      return []
    }
  }
  
  func updateData(name: String, updateName: String, updatePhoneNumber: String, updateImage: Data) {
    let fetchRequest: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    
    do {
      let phoneBooks = try context.fetch(fetchRequest)
      for phoneBook in phoneBooks {
        phoneBook.name = updateName
        phoneBook.phoneNumber = updatePhoneNumber
        phoneBook.pokemonImage = updateImage
      }
      saveContext()
    } catch {
      print(#function)
    }
  }
}
