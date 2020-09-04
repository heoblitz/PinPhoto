//
//  SelectGroupViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/04.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import YPImagePicker

class SelectGroupViewController: UIViewController {
    

    
    var items: [YPMediaItem]?
    var itemViewModel: ItemViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(completeTapped))
        barButtonItem.tintColor = .link
        navigationItem.rightBarButtonItem = barButtonItem
        // Do any additional setup after loading the view.
    }
    
    @objc private func completeTapped(_ sender: UIBarButtonItem) {
        guard let itemViewModel = itemViewModel, let items = items else { return }
        
        for item in items {
            switch item {
            case .photo(let photo):
                if itemViewModel.numberOfImages < 15 {
                    let id = itemViewModel.idForAdd
                    let imageData: Data? = photo.originalImage.data

                    itemViewModel.add(content: 0, image: imageData, text: nil, date: Date(), id: id)
                } else {
                    break
                }
            default:
                break
            }
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    static func storyboardInstance() -> SelectGroupViewController? {
        let storyboard = UIStoryboard(name: SelectGroupViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
}
