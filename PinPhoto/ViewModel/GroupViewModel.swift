//
//  GroupViewModel.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/03.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

class GroupViewModel {
    let groupDataManager = GroupDataManager.shared
    private weak var groupObserver: GroupObserver?
    private(set) var filterGroup: [Group] = []
    
    deinit {
        self.removeOberserver()
    }
    
    var groups: [Group] {
        return groupDataManager.groups
    }
    
    func group(by name: String) -> Group? {
        return groupDataManager.groups.filter { $0.name == name }.first
    }
    
    func load() {
        groupDataManager.load()
        
        if groupDataManager.groups.count == 0 {
            initialize()
        }
    }
    
    func save(at objects: [Group]) {
        groupDataManager.save(objects)
    }
    
    func add(name: String) {
        var addGroups = groupDataManager.groups
        addGroups.append(Group(sectionName: name, ids: []))
        groupDataManager.save(addGroups)
    }
    
    func remove(name: String) {
        let removeGroups = groupDataManager.groups
        groupDataManager.save(removeGroups.filter { $0.name != name })
    }
    
    func loadFilterGroup(name: String) {
        filterGroup = groupDataManager.groups.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
    
    func swap(_ start: IndexPath, _ end: IndexPath) {
        var swapGroups = groupDataManager.groups
        swapGroups.swapAt(start.row, end.row)
        groupDataManager.save(swapGroups)
    }
    
    func insertId(at name: String, ids add: [Int]) {
        var insertGroup = groupDataManager.groups
        if let index = insertGroup.firstIndex(where: { $0.name == name }) {
            let ids = insertGroup[index].ids
            insertGroup[index].ids = ids + add
            groupDataManager.save(insertGroup)
        }
    }
    
    func removeId(at name: String, ids remove: [Int]) {
        var removeGroup = groupDataManager.groups
        if let index = removeGroup.firstIndex(where: { $0.name == name }) {
            let removeIds = removeGroup[index].ids.filter { !remove.contains($0) }
            removeGroup[index].ids = removeIds
            groupDataManager.save(removeGroup)
        }
    }
    
    func attachObserver(_ observer: GroupObserver) {
        groupObserver = observer
        groupDataManager.obserbers.append(observer)
    }
    
    func removeOberserver() {
        groupDataManager.obserbers = groupDataManager.obserbers.filter { $0.groupIdentifier != self.groupObserver?.groupIdentifier }
    }
    
    private func initialize() {
        groupDataManager.save([Group(sectionName: "위젯에 표시될 항목", ids: [])])
        groupDataManager.load()
    }
}
