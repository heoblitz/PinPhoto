//
//  EditTextItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class EditTextItemViewController: UIViewController {
    
    @IBOutlet private weak var itemTextView: UITextView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    static let storyboardIdentifier: String = "editTextItem"
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemTextView.delegate = self
        self.itemTextView.text = item?.contentText
        // Do any additional setup after loading the view.
        self.itemTextView.isScrollEnabled = false
        self.itemTextView.layer.masksToBounds = false
        self.itemTextView.layer.shadowColor = UIColor.gray.cgColor
        self.itemTextView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.itemTextView.layer.shadowOpacity = 1.0
        self.itemTextView.layer.shadowRadius = 0.0
        
        self.setTextViewSize()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    func setTextViewSize() {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = itemTextView.sizeThatFits(size)
        
        itemTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

extension EditTextItemViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
