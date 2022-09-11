//
//  GroupDataRepository.swift
//  PinPhoto
//
//  Created by woody on 2022/09/11.
//  Copyright © 2022 won heo. All rights reserved.
//

import Foundation
import Combine

enum GroupDataError: Error {
  case saveFailed
  case decodeFailed
  case optionalWrappingFailed
  case isSelfReleased
  case invalid
}

protocol GroupDataRepositoryProtocol {
  func save(group: Group) -> AnyPublisher<Void, GroupDataError>
  func fetchGroups() -> AnyPublisher<[Group], GroupDataError>
}

final class GroupDataRepository {
  private enum Constant {
    static let fileName = "group.json"
    static let appGroupID = "group.com.wonheo.PinPhoto"
  }
  
  private let url: URL? = {
    var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constant.appGroupID)
    url?.appendPathComponent(Constant.fileName, isDirectory: false)
    return url
  }()
  
  private let jsonEncoder: JSONEncoder = {
    $0.outputFormatting = .prettyPrinted
    return $0
  }(JSONEncoder())
  private let jsonDecoder = JSONDecoder()
  
  private let fileManager: FileManager = FileManager.default
  
  private var cancellables = Set<AnyCancellable>()
}

extension GroupDataRepository: GroupDataRepositoryProtocol {
  func save(group: Group) -> AnyPublisher<Void, GroupDataError> {
    return Deferred { [weak self] in
      Future { [weak self] promise in
        guard let self = self else {
          promise(.failure(.isSelfReleased))
          return
        }
        
        guard let url = self.url else {
          promise(.failure(.optionalWrappingFailed))
          return
        }
        
        self.fetchGroups()
          .sink(receiveCompletion: { completion in
            guard case let .failure(error) = completion else {
              promise(.failure(.invalid))
              return
            }
            
            promise(.failure(error))
          }, receiveValue: { groups in
            do {
              let data = try self.jsonEncoder.encode(groups)
              if self.fileManager.fileExists(atPath: url.path) {
                try self.fileManager.removeItem(at: url)
              }
              self.fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            } catch _ {
              promise(.failure(.decodeFailed))
            }
          }).store(in: &self.cancellables)
      }
    }.eraseToAnyPublisher()
  }
  
  func fetchGroups() -> AnyPublisher<[Group], GroupDataError> {
    return Deferred { [weak self] in
      Future { [weak self] promise in
        guard let self = self else {
          promise(.failure(.isSelfReleased))
          return
        }
        
        guard let url = self.url else {
          promise(.failure(.optionalWrappingFailed))
          return
        }
        
        guard
          self.fileManager.fileExists(atPath: url.path),
          let data = FileManager.default.contents(atPath: url.path)
        else {
          promise(.success([]))
          return
        }
        
        do {
          let groups = try self.jsonDecoder.decode([Group].self, from: data)
          promise(.success(groups))
        } catch _ {
          promise(.failure(.decodeFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
}
