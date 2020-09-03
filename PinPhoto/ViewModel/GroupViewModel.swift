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
    
    var groups: [Group] {
        return groupDataManager.groups
    }
    
    func load() {
        groupDataManager.load(from: .documents)
        
        if groupDataManager.groups.count == 0 {
            groupDataManager.save([Group(sectionName: "위젯", ids: [0])], to: .documents)
            groupDataManager.load(from: .documents)
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
        let temp = swapGroups[start.row]
        swapGroups[start.row] = swapGroups[end.row]
        swapGroups[end.row] = temp
        
        groupDataManager.save(swapGroups, to: .documents)
    }
}
