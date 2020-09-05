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
    
    deinit {
        self.removeOberserver()
    }
    
    var groups: [Group] {
        return groupDataManager.groups
    }
    
    func load() {
        groupDataManager.load(from: .documents)
        
        if groupDataManager.groups.count == 0 {
            initialize()
        }
    }
    
    func save(at objects: [Group]) {
        groupDataManager.save(objects, to: .documents)
    }
    
    func add(name: String) {
        var addGroups = groupDataManager.groups
        addGroups.append(Group(sectionName: name, ids: []))
        groupDataManager.save(addGroups, to: .documents)
    }
    
    func swap(_ start: IndexPath, _ end: IndexPath) {
        var swapGroups = groupDataManager.groups
        swapGroups.swapAt(start.row, end.row)
        groupDataManager.save(swapGroups, to: .documents)
    }
    
    func insertId(at name: String, ids: [Int]) {
        var insertGroup = groupDataManager.groups
        if let index = insertGroup.firstIndex(where: { $0.name == name }) {
            insertGroup[index].ids.append(contentsOf: ids)
            groupDataManager.save(insertGroup, to: .documents)
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
        groupDataManager.save([Group(sectionName: "위젯", ids: [])], to: .documents)
        groupDataManager.load(from: .documents)
    }
}
