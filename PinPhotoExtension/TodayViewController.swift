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
    @IBOutlet weak var itemImageView: UIImageView!
    
    let itemViewModel = ItemViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        self.itemViewModel.loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let defaults = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
//        defaults?.synchronize()
//        textLabel.text = defaults?.string(forKey: "test") ?? "not work"
        
        textLabel.text = "\(itemViewModel.numberOfItems)"
        
        let item = itemViewModel.item(at: 0)
            
        self.itemImageView.image = itemViewModel.convertDataToImage(data: item.contentImage)

    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {

        if activeDisplayMode == NCWidgetDisplayMode.compact {
            //compact
            self.preferredContentSize = maxSize
        } else {
            //extended
            self.preferredContentSize = CGSize(width: maxSize.width, height: 200)
        }
    }
}
