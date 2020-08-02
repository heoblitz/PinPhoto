//
//  EditTextItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/15.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class CreateTextItemViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK:- Propertises
    static let storyboardIdentifier: String = "createTextItem"
    var mainItemCollectionView: UICollectionView?
    var itemViewModel: ItemViewModel?
    
    // MARk:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTextView.delegate = self
        self.inputTextView.isScrollEnabled = false
        self.saveButton.isEnabled = false
        
        self.inputTextView.layer.backgroundColor = UIColor.systemBackground.cgColor
        self.inputTextView.layer.masksToBounds = false
        self.inputTextView.layer.shadowColor = UIColor.gray.cgColor
        self.inputTextView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.inputTextView.layer.shadowOpacity = 1.0
        self.inputTextView.layer.shadowRadius = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.inputTextView.becomeFirstResponder()
    }
    
    // MARK:- @IBAction Methods
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let id = itemViewModel?.idForAdd ?? 0
        itemViewModel?.add(content: 1, image: nil, text: inputTextView.text, date: Date(), id: id)
        itemViewModel?.loadItems()
        
        mainItemCollectionView?.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- UITextView Delegate
extension CreateTextItemViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        if !textView.text.isEmpty {
            self.saveButton.isEnabled = true
        } else {
            self.saveButton.isEnabled = false
        }
    }
}
