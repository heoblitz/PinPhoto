//
//  SceneDelegate.swift
//  PinPhoto
//
//  Created by won heo on 2020/06/29.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    ViewStore(appStore).send(.sceneWillConnect)
    self.window = UIWindow(windowScene: scene)
    self.window?.rootViewController = UIHostingController(rootView: AppView(store: appStore))
    self.window?.makeKeyAndVisible()
  }
}

