//
//  URLextension.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/27.
//  Copyright © 2020 won heo. All rights reserved.
//

import CoreData

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
