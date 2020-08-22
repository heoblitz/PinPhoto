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
    @IBOutlet private weak var itemScrollView: UIScrollView!
    @IBOutlet private weak var itemImageView: UIImageView!
    
    // MARK:- Propertises
    var itemViewModel: ItemViewModel?
    var item: Item?
    
    private var shouldBackgroundViewDark: Bool = false {
        didSet {
            if shouldBackgroundViewDark {
                view.backgroundColor = UIColor.black
            } else {
                view.backgroundColor = UIColor.systemBackground
            }
        }
    }
    
    private var isStatusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    // MARk:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = itemViewModel?.creationData(date: item?.updateDate)
        self.itemImageView.image = itemViewModel?.convertDataToImage(data: item?.contentImage)
        
        self.itemScrollView.contentInsetAdjustmentBehavior = .never
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.itemImageView.addGestureRecognizer(tapGesture)
        self.itemImageView.isUserInteractionEnabled = true
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> EditImageItemViewController? {
        let storyboard = UIStoryboard(name: EditImageItemViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    @objc func imageTapped() {
        isStatusBarHidden.toggle()
        shouldBackgroundViewDark.toggle()
        tabBarController?.tabBar.isHidden.toggle()
        navigationController?.navigationBar.isHidden.toggle()
    }
}
