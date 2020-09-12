//
//  TodayViewController.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/27.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemCollectionView: UICollectionView!
    @IBOutlet private weak var itemCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var noticeLabel: UILabel!
    
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var prevButton: UIButton!
    
    @IBOutlet private weak var nextButtonImageView: UIImageView!
    @IBOutlet private weak var prevButtonImageView: UIImageView!
    
    // MARK:- Properties
    private let itemViewModel = ItemViewModel(.widget)
    private let widgetViewModel = WidgetViewModel()

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
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        itemViewModel.loadItems()
        pageControl.numberOfPages = itemViewModel.numberOfItems
        nextButtonImageView.layer.opacity = 0.5
        prevButtonImageView.layer.opacity = 0.5
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
    }
        
    override func viewWillAppear(_ animated: Bool) {
        // 콜렉션 뷰 높이 지정
        let height = widgetViewModel.height
        itemCollectionViewHeight.constant = CGFloat(height)
        itemCollectionView.reloadData()
        itemCollectionView.layoutIfNeeded()
        
        // 콜렉션 뷰 위치 지정
        if let index = widgetViewModel.currentIndex {
            let indexRow = min(itemViewModel.numberOfItems, index)
            pageControl.currentPage = indexRow
            itemCollectionView.scrollToItem(at: IndexPath(item: indexRow, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            let indexRow = 0
            pageControl.currentPage = indexRow
            itemCollectionView.scrollToItem(at: IndexPath(item: indexRow, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    // MARK:- Methods
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let nextIndex = min(pageControl.currentPage + 1, pageControl.numberOfPages - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        pageControl.currentPage = nextIndex
        widgetViewModel.currentIndex = nextIndex
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // MARK:- @IBAction Methods
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        
        pageControl.currentPage = prevIndex
        widgetViewModel.currentIndex = prevIndex
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK:- NCWidgetProviding
extension TodayViewController: NCWidgetProviding {
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
            preferredContentSize = maxSize
            shouldContentAppear = false

        } else {
            //extended
            let height = widgetViewModel.height
            preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(height))
            shouldContentAppear = true
        }
    }
}

// MARK:- UICollectionView Data Source
extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemViewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ExtensionItemCell else {
            return UICollectionViewCell()
        }
        let item = itemViewModel.item(at: indexPath.item)
        
        cell.update(item: item)
        cell.contentImageView.contentMode = widgetViewModel.shouldImageFill ? .scaleToFill : .scaleAspectFit
        
        return cell
    }
}

// MARK:- UICollectionView Delegate FlowLayout
extension TodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemCollectionView.bounds.width
        let height = itemCollectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
