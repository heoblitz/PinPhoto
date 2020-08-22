//
//  HomeNavigationController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override open var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override open var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}
