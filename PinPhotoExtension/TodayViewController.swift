//
//  TodayViewController.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/27.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var textLabel: UILabel!
    
    let itemViewModel = ItemViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let defaults = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
//        defaults?.synchronize()
//        textLabel.text = defaults?.string(forKey: "test") ?? "not work"
        
        itemViewModel.loadItems()
        itemViewModel.printID()
        textLabel.text = "\(itemViewModel.numberOfItems)"
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
