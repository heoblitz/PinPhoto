//
//  GroupDataManager.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/03.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

class GroupDataManager {
    static let shared = GroupDataManager()
    static let fileName: String = "group.json"
    private(set) var groups: [Group] = []
    var obserbers: [GroupObserver] = []
    
    enum Directory {
        case documents
        case caches
        
        var url: URL? {
            let path: FileManager.SearchPathDirectory
            switch self {
            case .documents:
                path = .documentDirectory
            case .caches:
                path = .cachesDirectory
            }
            return FileManager.default.urls(for: path, in: .userDomainMask).first
        }
    }
    
    func save(_ obj: [Group], to directory: Directory) {
        guard let url = directory.url?.appendingPathComponent(GroupDataManager.fileName, isDirectory: false) else { return }
        print("---> save to here: \(url)")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(obj)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch let error {
            print("---> Failed to store: \(error.localizedDescription)")
        }
    }
    
    func load(from directory: Directory) {
        guard let url = directory.url?.appendingPathComponent(GroupDataManager.fileName, isDirectory: false) else { return }
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        
        let decoder = JSONDecoder()
        
        do {
            groups = try decoder.decode([Group].self, from: data)
        } catch let error {
            print("---> Failed to decode: \(error)")
        }
        noticeObserbers()
    }
    
    func destructive() {
        let directory: Directory = .documents
        guard let url = directory.url?.appendingPathComponent(GroupDataManager.fileName, isDirectory: false) else { return }
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func noticeObserbers() {
        for obserber in obserbers {
            obserber.updateGroup()
        }
    }
}
