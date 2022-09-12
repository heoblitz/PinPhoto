//
//  MockCoreDataRepository.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import Foundation
import Combine

// TODO: 추후 Mock 구현하기
//final class MockCoreDataRepository {}
//
//extension MockCoreDataRepository: CoreDataRepositoryProtocol {
//  func save(itemDto: ItemDto) -> AnyPublisher<Item, PinPhotoError> {
//    return Deferred {
//      Future { promise in
//        promise(.success(()))
//      }
//    }.eraseToAnyPublisher()
//  }
//
//  func remove(item: Item) -> AnyPublisher<Item, PinPhotoError> {
//    return Deferred {
//      Future { promise in
//        promise(.success(()))
//      }
//    }.eraseToAnyPublisher()
//  }
//
//  func edit(item: Item, with itemDto: ItemDto) -> AnyPublisher<Item, PinPhotoError> {
//    return Deferred {
//      Future { promise in
//        promise(.success(()))
//      }
//    }.eraseToAnyPublisher()
//  }
//
//  func fetchItems() -> AnyPublisher<[Item], PinPhotoError> {
//    return Deferred {
//      Future { promise in
//        promise(.success(()))
//      }
//    }.eraseToAnyPublisher()
//  }
//}
