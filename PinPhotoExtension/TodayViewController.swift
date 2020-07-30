//
//  TodayViewController.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/27.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet private weak var itemCollectionView: UICollectionView!
    @IBOutlet private weak var noticeLabel: UILabel!
    
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var prevButton: UIButton!
    
    @IBOutlet private weak var nextButtonImageView: UIImageView!
    @IBOutlet private weak var prevButtonImageView: UIImageView!

    private let itemViewModel = ItemViewModel()

    private var shouldContentAppear: Bool = false {
        didSet {
            if shouldContentAppear {
                itemCollectionView.isHidden = false
                nextButtonImageView.isHidden = false
                prevButtonImageView.isHidden = false
                pageControl.isHidden = false
                
                noticeLabel.isHidden = true
                nextButton.isEnabled = true
                prevButton.isEnabled = true
            } else {
                itemCollectionView.isHidden = true
                nextButtonImageView.isHidden = true
                prevButtonImageView.isHidden = true
                pageControl.isHidden = true
                
                noticeLabel.isHidden = false
                nextButton.isEnabled = false
                prevButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        self.itemViewModel.loadItems()
        
        self.pageControl.numberOfPages = self.itemViewModel.numberOfItems
        self.nextButtonImageView.layer.opacity = 0.5
        self.prevButtonImageView.layer.opacity = 0.5
                
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
    }
        
    override func viewWillAppear(_ animated: Bool) {
        self.itemCollectionView.reloadData()
        
        if let index = getIndexPath(), index <= self.itemViewModel.numberOfItems {
            self.pageControl.currentPage = index
            self.itemCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            let index = self.itemViewModel.numberOfItems
            self.pageControl.currentPage = index
            self.itemCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == NCWidgetDisplayMode.compact {
            //compact
            self.preferredContentSize = maxSize
            shouldContentAppear = false

        } else {
            //extended
            self.preferredContentSize = CGSize(width: maxSize.width, height: 300)
            shouldContentAppear = true
        }
    }
    
    func saveIndexPath(at index: Int) {
        let defaults = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
        defaults?.set(index, forKey: "indexPath")
    }
    
    func getIndexPath() -> Int? {
        let defaults = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
        return defaults?.integer(forKey: "indexPath")
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let nextIndex = min(pageControl.currentPage + 1, pageControl.numberOfPages - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        pageControl.currentPage = nextIndex
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        saveIndexPath(at: nextIndex)
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        
        pageControl.currentPage = prevIndex
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        saveIndexPath(at: prevIndex)
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemViewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ExtensionItemCell else {
            return UICollectionViewCell()
        }
        let item = itemViewModel.item(at: indexPath.item)
        
        switch item.contentType {
        case 0:
            cell.itemtype = "image"
            cell.contentImageView.image = itemViewModel.convertDataToImage(data: item.contentImage)
        case 1:
            cell.itemtype = "text"
            cell.contentTextLabel.text = item.contentText
        default:
            break
        }
        
        return cell
    }
}

extension TodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemCollectionView.bounds.width
        let height = itemCollectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
