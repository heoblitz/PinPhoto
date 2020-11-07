#  사진 콕


![swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![pod](https://img.shields.io/badge/pod-1.9.3-blue)
![version](https://img.shields.io/badge/version-1.4.0-blue)

![](temp/header.jpg)

> 위젯에서 사진, 메모를 쉽게 확인

[<img src="https://developer.apple.com/assets/elements/icons/download-on-the-app-store/download-on-the-app-store.svg" width="200">](https://apps.apple.com/kr/app/%EC%82%AC%EC%A7%84-%EC%BD%95/id1526039511)

## 사용 프레임워크
- UIKit
- SwiftUI
- WidgetKit
- StoreKit

## 아키텍처 
- MVVM 패턴을 최대한 반영하고자 했습니다.

<br>

# 목차
- [기능](#feature)
- [설계](#structure)
- [문제 해결](#troubleshooting)
- [배운 점](#learned)

<br> 

# 기능 <a id="feature"></a>

## Today Extension
<img src="temp/Today_Extension.gif" width="230" height="450" />  
  
## Widget ( iOS 14 )
<img src="temp/Widget_iOS14.gif" width="230" height="450" />  
  
## Group & Search
<img src="temp/Group_Search.gif" width="230" height="450" />  

## Setting
<img src="temp/setting.gif" width="230" height="450" />  
<br>

# 설계 <a id="structure"></a>

## Model & ViewModel

![](temp/Model.jpeg)

## Controller & View
![](temp/homeViewController.jpeg)

# 문제 해결 <a id="troubleshooting"></a>

## Today Extension Memory Issue
  
- 문제점
    - "Enable to Load" 라는 알림이 남고 위젯이 로드되지 않는 현상
    - Today Extension 의 경우 시스템에서 16MB 로 제한됨
    - https://reactnative.dev/docs/app-extensions
- 해결
    - 사용자가 위젯에 추가할 수 있는 사진 개수를 제한하였음 (20개)
    - 또한 NSpredicate 를 통해 필요한 사진만 CoreData 에서 Fetch 하도록 구성
    ```swift
        fetchRequest.sortDescriptors = [idSort]
        fetchRequest.predicate = NSPredicate(format: "id IN %@", newIds)
    ```
<br>

## Today Extension Collection View Scroll Issue

- 문제점
    - iOS 13 -> 14 로 업데이트 후 위젯 콜렉션 뷰가 스크롤 되지 않는 문제
    - 기존 방식은 scrollToItem IndexPath 를 넘겨서 버튼으로 스크롤 하였음

- 해결
    - 직접 scrollView 에 bounds origin 을 변경하였더니 스크롤이 됨
    - 따라서 SetContentOffSet 통해 스크롤하는 메소드 설계

    ```swift
    func scrollItemCollectionView(to index: Int, animated: Bool) {
        let spacing: CGFloat = itemCollectionView.bounds.width
        
        itemCollectionView.setContentOffset(CGPoint(x: spacing * CGFloat(index), y: 0), animated: animated)
    }
    ```
<br>

## Retain Cycle
- 문제점
    - HomeDetailViewController 가 deinit 되지 않는 문제
    - Observer 를 등록하고 제거하지 않았고 Model 에서 계속 VC 를 참조하여 발생
- 해결
    - 등록한 Observer 을 삭제하기 위해 Protocol 에 구분자를 추가하였음
    - VC 가 사라질 때 등록한 Obserber 제거 하도록 구성
    ```swift
    // HomeDetailViewController.swift

    class HomeDetailViewController: UIViewController {
        override func viewDidDisappear(_ animated: Bool) {
            if isMovingFromParent {  // Parent VC 로 이동할 때 제거
                groupViewModel.removeOberserver(self)
            }
        }
        ...
    }

    extension HomeDetailViewController: GroupObserver {
        var groupIdentifier: String {
            return HomeDetailViewController.observerName()
        }
        
        func updateGroup() {
            guard let group = group, let newGroup = groupViewModel.group(by: group.name) else { return }
            
            itemViewModel.loadFromIds(ids: newGroup.ids)
            itemCollectionView.reloadData()
        }
    }
    ```

<br>

# 배운 점 <a id="learned"></a>

## 초기 모델 설계가 중요하다는 점
- 이유
    - 처음 진행한 iOS 프로젝트로 DB 가 어떤 것이 있는지 몰랐던 상태.
    - CoreData 로 이미지 & 텍스트 데이터를 저장했지만, 대부분의 다른 프로젝트들은
    - 이미지는 document 에 저장하고 관리를 JSON 파일로 하는 방식이 많았음
- 결과
    - 앱의 동작에는 문제가 없지만, 앞으로 다른 프로젝트를 진행할 때
    - 좋은 구조, 확장성을 생각하며 앱을 설계해야 겠다는 생각을 하게 되었음
    
<br>

## 라이브러리를 사용할 때 화면 전환
- 이유
    - 이미지 피커는 YPImagePicker 라는 서드파티 라이브러리를 사용했는데
    - 사진 선택 후 별도의 그룹 선택 화면이 필요했음 
    - 직접 라이브러리를 수정하려 했지만, 좋은 방식이 아니라고 생각했음
- 결과
    - 디버깅을 통해 제공되는 picker 가 Navigation Controller 를 상속 받음을 알게되었고,
    - 따라서 필요한 그룹 선택 VC 를 Push 하여 필요한 앱 동작 구현을 할 수 있었음
    - 앱을 만들면서 화면 전환에 대한 이해가 한층 높아졌다고 생각됨

<br>

## 아키텍처에 대한 학습
- 이유
    - 이번 프로젝트에서 MVVM 을 적용했지만, Controller 에서 Model 로 접근하는 코드만 ViewModel 로
    - 단순히 옮겼다는 생각이 들었고, MVVM 패턴을 잘 이해하고 있지 않다는 생각을 하게됨
    - best practice 를 찾으려 했지만 일관된 코드를 찾기 어려웠음
- 결과
    - MVVM 모델은 표준화된 틀이 없기 때문에 패턴에 이해도에 따라 코드가 차이난다는 것을 알게됨
    - 그에 따라 ReactorKit, RIBs ... 같은 아키텍처가 등장했다고 생각되었음.
    - Swift, UIKit 과 더불어 아키텍처에 대한 학습도 이어나가야 겠다는 생각을 하게됨.
    - https://www.youtube.com/watch?v=3XS6xLzKRjc