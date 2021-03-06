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
    
    private let url: URL? = {
        var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.wonheo.PinPhoto")
        url?.appendPathComponent(GroupDataManager.fileName, isDirectory: false)
        return url
    }()
    
    private(set) var groups: [Group] = []
    private(set) var observers: [GroupObserver] = []
    
    private init() {}
    
    func save(_ obj: [Group]) {
        guard let url = url else { return }
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
    
    func load() {
        guard let url = url else { return }
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        
        let decoder = JSONDecoder()
        
        do {
            groups = try decoder.decode([Group].self, from: data)
        } catch let error {
            print("---> Failed to decode: \(error)")
        }
        // noticeObservers()
    }
    
    func destructive() {
        guard let url = url else { return }

        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print(error.localizedDescription)
        }
        groups = []
        initialize()
    }

    func initialize() {
        save([Group(sectionName: "위젯에 표시될 항목", ids: [])])
        load()
    }
    
    func addObserver(_ target: GroupObserver) {
        observers.append(target)
    }
    
    func removeObserver(_ target: GroupObserver) {
        observers = observers.filter { $0.groupIdentifier != target.groupIdentifier }
    }
    
    func noticeObservers() {
        for observer in observers {
            observer.updateGroup()
        }
    }
}
