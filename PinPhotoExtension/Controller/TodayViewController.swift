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
    private let defaults: UserDefaults? = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
    private let itemViewModel = ItemViewModel()
    private var isImageFill: Bool = false

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
        // Do any additional setup after loading the view.
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        self.itemViewModel.loadItems()
        self.isImageFill = getWidgetImageFill() ?? false
        
        self.pageControl.numberOfPages = self.itemViewModel.numberOfItems
        self.nextButtonImageView.layer.opacity = 0.5
        self.prevButtonImageView.layer.opacity = 0.5
                
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
    }
        
    override func viewWillAppear(_ animated: Bool) {
        // 콜렉션 뷰 높이 지정
        let height = getWidgetHeight() ?? 300
        self.itemCollectionViewHeight.constant = CGFloat(height)
        self.itemCollectionView.reloadData()
        self.itemCollectionView.layoutIfNeeded()
        
        // 콜렉션 뷰 위치 지정
        if let index = getIndexPath() {
            let indexRow = min(self.itemViewModel.numberOfItems, index)
            self.pageControl.currentPage = indexRow
            self.itemCollectionView.scrollToItem(at: IndexPath(item: indexRow, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            let indexRow = 0
            self.pageControl.currentPage = indexRow
            self.itemCollectionView.scrollToItem(at: IndexPath(item: indexRow, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        // 이미지 모드 설정
        self.isImageFill = getWidgetImageFill() ?? false
    }
    
    // MARK:- Methods
    private func saveIndexPath(at index: Int) {
        defaults?.set(index, forKey: "indexPath")
    }
    
    private func getIndexPath() -> Int? {
        return defaults?.integer(forKey: "indexPath")
    }
    
    private func getWidgetHeight() -> Float? {
        return defaults?.float(forKey: "widgetHeight")
    }
    
    private func getWidgetImageFill() -> Bool? {
         return defaults?.bool(forKey: "widgetImageFill")
     }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let nextIndex = min(pageControl.currentPage + 1, pageControl.numberOfPages - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        pageControl.currentPage = nextIndex
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        saveIndexPath(at: nextIndex)
    }
    
    // MARK:- @IBAction Methods
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        
        pageControl.currentPage = prevIndex
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        saveIndexPath(at: prevIndex)
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
            self.preferredContentSize = maxSize
            shouldContentAppear = false

        } else {
            //extended
            let height = getWidgetHeight() ?? 300
            self.preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(height))
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
        
        switch item.contentType {
        case 0:
            cell.itemtype = "image"
            cell.contentImageView.image = item.contentImage?.image
            cell.contentImageView.contentMode = isImageFill ? .scaleToFill : .scaleAspectFit
        case 1:
            cell.itemtype = "text"
            cell.contentTextLabel.text = item.contentText
        default:
            break
        }
        
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
