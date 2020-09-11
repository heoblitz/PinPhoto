//
//  HomeNavigationController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
     
    let addButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAddButtonView()
    }
    
    override open var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    func presentAddButtonView() {
        addButtonView.addSubview(plusImageView)
        view.addSubview(addButtonView)
        prepareConstraint()
    }
    
    func dismissAddButtonView() {
        plusImageView.removeFromSuperview()
        addButtonView.removeFromSuperview()
    }
    
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            addButtonView.widthAnchor.constraint(equalToConstant: 50),
            addButtonView.heightAnchor.constraint(equalToConstant: 50),
            addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            addButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            plusImageView.widthAnchor.constraint(equalToConstant: 30),
            plusImageView.heightAnchor.constraint(equalToConstant: 30),
            plusImageView.centerXAnchor.constraint(equalTo: addButtonView.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: addButtonView.centerYAnchor)
        ])
    }
}
