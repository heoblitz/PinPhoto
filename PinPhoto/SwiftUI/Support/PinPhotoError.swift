//
//  PinError.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import Foundation

enum PinPhotoError: Error {
  case saveFailed
  case decodeFailed
  case fetchFailed
  case optionalUnwrappingFailed
  case isSelfReleased
  case invalid
}
