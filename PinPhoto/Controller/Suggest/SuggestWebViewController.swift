//
//  SuggestWebViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/12/24.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import WebKit

final class SuggestWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var suggestLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let link = suggestLink, let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    static func storyboardInstance() -> SuggestWebViewController? {
        let storyboard = UIStoryboard(name: SuggestWebViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    @IBAction func dissmissBarButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
