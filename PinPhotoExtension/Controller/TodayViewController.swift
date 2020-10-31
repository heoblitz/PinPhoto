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
    private let itemViewModel = ItemViewModel()
    private let widgetViewModel = WidgetViewModel()
    private let groupViewModel = GroupViewModel()
    
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
        groupViewModel.load()
        
        guard let ids = groupViewModel.groups.first?.ids else { return }
        itemViewModel.loadFromIds(ids: ids)
        
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
        if let current = widgetViewModel.currentIndex {
            let index = min(itemViewModel.items.count - 1, current)
            widgetViewModel.currentIndex = index
            pageControl.currentPage = index
            scrollItemCollectionView(to: index, animated: false)
        } else {
            let index = 0
            widgetViewModel.currentIndex = index
            pageControl.currentPage = index
            scrollItemCollectionView(to: index, animated: false)
        }
    }
    
    // MARK:- Methods
    private func scrollItemCollectionView(to index: Int, animated: Bool) {
        // let origin: CGFloat = itemCollectionView.bounds.origin.x
        let spacing: CGFloat = itemCollectionView.bounds.width
        
        itemCollectionView.setContentOffset(CGPoint(x: spacing * CGFloat(index), y: 0), animated: animated)
    }
    
    // MARK:- @IBAction Methods
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let index: Int = widgetViewModel.currentIndex else { return }
        let next: Int = index + 1
        
        if next < itemViewModel.items.count {
            widgetViewModel.currentIndex = next
            pageControl.currentPage = next
            scrollItemCollectionView(to: next, animated: true)
        }
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        guard let index: Int = widgetViewModel.currentIndex else { return }
        let next: Int = index - 1
        
        if next >= 0 {
            widgetViewModel.currentIndex = next
            pageControl.currentPage = next
            scrollItemCollectionView(to: next, animated: true)
        }
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
