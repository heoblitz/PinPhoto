//
//  AppDelegate.swift
//  PinPhoto
//
//  Created by won heo on 2020/06/29.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Item")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error {
        fatalError("Unresolved error, \((error as NSError).userInfo)")
      }
    })
    return container
  }()

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

