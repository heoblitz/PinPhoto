//
//  ManualViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/02.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var manualCollectionView: UICollectionView!
    @IBOutlet private weak var manualPageControl: UIPageControl!
    
    // MARK:- Propertises
    private let assetNames: [String] = [
        "manual1", "manual2", "manual3", "manual4", "manual5", "manual6", "manual7", "manual8"
    ]
    
    private let manualTexts: [String] = [
        "1. Today Extension 추가 방법 \n먼저 아이템을 추가해주세요",
        "홈 화면에서 왼쪽으로 스크롤하고 \n편집을 클릭해주세요",
        "iOS 14 에서는 사용자화를 클릭하고 \n사진 콕 위젯을 추가해주세요",
        "> 버튼을 누르고 사용해주세요",
        "2. iOS 14 위젯 추가 방법 \n홈 화면에서 왼쪽으로 스크롤 해주세요.",
        "편집 버튼을 클릭하고 왼쪽 상단에 더하기 버튼을 눌러주세요.",
        "해당 화면에서 위젯을 추가해주세요",
        "홈 화면 위젯에 나타날 항목을 선택해주세요."
    ]
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        manualCollectionView.dataSource = self
        manualCollectionView.delegate = self
        manualPageControl.numberOfPages = assetNames.count
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> ManualViewController? {
        let storyboard = UIStoryboard(name: ManualViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }

    // MARK:- @IBAction Methods
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- UICollectionView Data Source
extension ManualViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualCustomCell.cellIdentifier, for: indexPath) as? ManualCustomCell else {
            return UICollectionViewCell()
        }
        
        cell.manualImageView.image = UIImage(named: assetNames[indexPath.item])
        cell.manualTextLabel.text = manualTexts[indexPath.item]
        
        return cell
    }
}

// MARK:- UICollectionView Delegate
extension ManualViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = manualCollectionView.contentOffset.x / manualCollectionView.frame.size.width;
        
        manualPageControl.currentPage = Int(index)
    }
}

// MARK:- UICollectionView Delegate Flow Layout
extension ManualViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
