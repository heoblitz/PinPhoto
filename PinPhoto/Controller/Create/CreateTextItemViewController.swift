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
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var contentView: UIView!
    // @IBOutlet private weak var saveButton: UIButton!
    
    // MARK:- Propertises    
    let cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    let nextBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(saveButtonTapped))
        barButtonItem.tintColor = .link
        return barButtonItem
    }()
    
    // MARk:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = nextBarButtonItem
        nextBarButtonItem.isEnabled = false
        prepareInputTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextView.becomeFirstResponder()
    }
    
    // MARk:- Methods
    static func storyboardInstance() -> CreateTextItemViewController? {
        let storyboard = UIStoryboard(name: CreateTextItemViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareInputTextView() {
        inputTextView.delegate = self
        inputTextView.isScrollEnabled = false
        inputTextView.layer.backgroundColor = UIColor.systemBackground.cgColor
        inputTextView.layer.masksToBounds = false
        inputTextView.layer.shadowColor = UIColor.gray.cgColor
        inputTextView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        inputTextView.layer.shadowOpacity = 1.0
        inputTextView.layer.shadowRadius = 0.0
    }
    
    // MARK:- @IBAction Methods
    @objc private func saveButtonTapped(_ sender: UIButton) {
        print("Tapped")
        guard let vc = SelectGroupViewController.storyboardInstance() else { return }
        
        vc.selectionType = .addText
        vc.itemText = inputTextView.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc private func viewTapped() {
        print("??")
        inputTextView.resignFirstResponder()
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
            nextBarButtonItem.isEnabled = true
        } else {
            nextBarButtonItem.isEnabled = false
        }
    }
}
