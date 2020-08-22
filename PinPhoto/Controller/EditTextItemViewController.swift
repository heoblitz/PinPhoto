//
//  EditTextItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class EditTextItemViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemTextView: UITextView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    // MARK:- Propertises
    var itemViewModel: ItemViewModel?
    var item: Item?
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        
        self.navigationItem.title = itemViewModel?.creationData(date: item?.updateDate)
        self.itemTextView.delegate = self
        self.itemTextView.text = item?.contentText
        self.itemTextView.isScrollEnabled = false
        self.itemTextView.layer.backgroundColor = UIColor.systemBackground.cgColor
        self.itemTextView.layer.masksToBounds = false
        self.itemTextView.layer.shadowColor = UIColor.gray.cgColor
        self.itemTextView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.itemTextView.layer.shadowOpacity = 1.0
        self.itemTextView.layer.shadowRadius = 0.0
        self.setTextViewSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.itemTextView.becomeFirstResponder()
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> EditTextItemViewController? {
        let storyboard = UIStoryboard(name: EditTextItemViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    private func setTextViewSize() {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = itemTextView.sizeThatFits(size)
        
        itemTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    // MARK:- @IBAction Methods
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let item = item {
            itemViewModel?.edit(content: item.contentType, image: nil, text: itemTextView.text, date: item.updateDate, id: item.id)
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK:- UITextView Delegate
extension EditTextItemViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty, textView.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
