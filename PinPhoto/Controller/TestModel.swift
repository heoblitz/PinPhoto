//
//  TestModel.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/13.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

struct TestModel {
    let contentType: ContentType?
    let contentImage: UIImage?
    let contentText: String?
    let updateDate: Date?
    let id: [String]?
}

public enum ContentType {
    case image
    case text
}

class TestViewModel {
    private var tests: [TestModel] = []
    
    var numberOftests: Int {
        return tests.count
    }
    
    func remove(at index: Int) {
        tests.remove(at: index)
    }

    func addTest(target: TestModel) {
        tests.append(target)
    }
    
    func getTest(at index: Int) -> TestModel {
        return tests[index]
    }
}
