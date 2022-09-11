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

let mainStore = Store<MainState, MainAction>(
  initialState: .init(),
  reducer: mainReducer,
  environment: .mock
)

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    ViewStore(mainStore).send(.sceneWillConnect)
    self.window = UIWindow(windowScene: scene)
    self.window?.rootViewController = UIHostingController(rootView: MainView(store: mainStore))
    self.window?.makeKeyAndVisible()
  }
}

