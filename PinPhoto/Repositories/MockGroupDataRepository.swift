//
//  MockGroupDataRepository.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import Foundation
import Combine

final class MockGroupDataRepository {}

extension MockGroupDataRepository: GroupDataRepositoryProtocol {
  func save(group: Group) -> AnyPublisher<Void, PinPhotoError> {
    return Deferred {
      Future { promise in
        promise(.success(()))
      }
    }.eraseToAnyPublisher()
  }
  
  func fetchGroups() -> AnyPublisher<[Group], PinPhotoError> {
    return Deferred {
      Future { promise in
        let mockGroups: [Group] = [
          .init(sectionName: "학교", ids: [1]),
          .init(sectionName: "해외 여행", ids: []),
          .init(sectionName: "QR 모음", ids: []),
          .init(sectionName: "출입증", ids: [])
        ]
        
        promise(.success(mockGroups))
      }
    }.eraseToAnyPublisher()
  }
}
