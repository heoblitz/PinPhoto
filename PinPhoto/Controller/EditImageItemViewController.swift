//
//  EditImageItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class EditImageItemViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemImageView: UIImageView!
    
    // MARK:- Propertises
    var itemViewModel: ItemViewModel?
    var item: Item?
    
    // MARk:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = itemViewModel?.creationData(date: item?.updateDate)
        self.itemImageView.image = itemViewModel?.convertDataToImage(data: item?.contentImage)
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> EditImageItemViewController? {
        let storyboard = UIStoryboard(name: EditImageItemViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
}
