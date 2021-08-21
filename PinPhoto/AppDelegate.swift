//
//  AppDelegate.swift
//  PinPhoto
//
//  Created by won heo on 2020/06/29.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Item") // 파일명
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // core data url
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         print(urls[urls.count-1] as URL)

        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return .init(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

