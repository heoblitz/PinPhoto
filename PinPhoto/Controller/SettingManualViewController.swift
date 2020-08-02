//
//  SettingManualViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/02.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class SettingManualViewController: UIViewController {
    @IBOutlet private weak var manualCollectionView: UICollectionView!
    @IBOutlet private weak var manualPageControl: UIPageControl!
    
    let assetNames: [String] = [
        "manual1", "manual2", "manual3", "manual4"
    ]
    
    let manualTexts: [String] = [
        "먼저 아이템을 추가해주세요",
        "홈 화면에서 왼쪽으로 스크롤하고 \n위젯을 클릭해주세요",
        "사진 콕 위젯을 추가해주세요",
        "> 버튼을 누르고 사용해주세요"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manualCollectionView.dataSource = self
        self.manualCollectionView.delegate = self
        self.manualPageControl.numberOfPages = assetNames.count
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingManualViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "manualCell", for: indexPath) as? ManualCustomCell else {
            return UICollectionViewCell()
        }
        
        cell.manualImageView.image = UIImage(named: assetNames[indexPath.item])
        cell.manualTextLabel.text = manualTexts[indexPath.item]
        
        return cell
    }
}

extension SettingManualViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = self.manualCollectionView.contentOffset.x / self.manualCollectionView.frame.size.width;
        
        self.manualPageControl.currentPage = Int(index)
    }
}

extension SettingManualViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
