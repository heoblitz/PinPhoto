//
//  MainTabBarController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/13.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
}
