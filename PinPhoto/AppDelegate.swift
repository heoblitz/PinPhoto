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
        // Override point for customization after application launch.
        
        // core data url
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         print(urls[urls.count-1] as URL)
        
        checkAppUpdated()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func checkAppUpdated() {
        let defaults = UserDefaults.standard
        let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let previousVersion = defaults.string(forKey: "appVersion")

        if previousVersion == nil {
            // first launch
            defaults.set(currentAppVersion, forKey: "appVersion")
            defaults.synchronize()

            let itemViewModel = ItemViewModel()
            let groupViewModel = GroupViewModel()

            itemViewModel.load()
            groupViewModel.load()

            let items: [Item] = itemViewModel.items
            var id: Int64 = 0
            var copyItems: [ItemCopy] = []

            for item in items {
                let copy = ItemCopy(item: item)
                copyItems.append(copy)
            }
            
            itemViewModel.shared.destructive() // 모든 데이터 삭제
            
            for copy in copyItems { // id 다시 지정한 뒤 저장
                itemViewModel.add(content: copy.contentType, image: copy.contentImage, text: copy.contentText, date: copy.updateDate, id: id)
                groupViewModel.insertId(at: "위젯에 표시될 항목", ids: [Int(id)])
                groupViewModel.load()

                id += 1
            }
        } else if previousVersion == currentAppVersion {
            // same version
        } else {
            // other version
            defaults.set(currentAppVersion, forKey: "appVersion")
            defaults.synchronize()
        }
    }
}

