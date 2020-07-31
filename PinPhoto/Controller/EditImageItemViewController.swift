//
//  EditImageItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class EditImageItemViewController: UIViewController {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    
    static let storyboardIdentifier: String = "editImageItem"
    var itemViewModel: ItemViewModel?
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = itemViewModel?.creationData(date: item?.updateDate)
        self.itemImageView.image = itemViewModel?.convertDataToImage(data: item?.contentImage)
    }
}
