//
//  Group.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit

struct Group {
    let groupId: Int
    let name: String
    let image: UIImage?
    
    private static let userGroupsNames = ["Автолюбители", "Гринпис", "Greenpeace", "Wow videos"]
    private static let aveliableGroupsNames = ["Библиофилы", "Программисты IOS", "Готовим вкусно!", "Автолюбители", "Гринпис", "Greenpeace", "Wow videos"]
    
    static let userGroups: [Group] = {
        var groups = [Group]()
        
        for (index, group) in userGroupsNames.enumerated() {
            groups.append(Group(groupId: index, name: group, image: UIImage(named: group)))
        }
        return groups
    }()
    
    static let aveliableGroups: [Group] = {
        var groups = [Group]()
        
        for (index, group) in aveliableGroupsNames.enumerated() {
            groups.append(Group(groupId: index, name: group, image: UIImage(named: group)))
        }
        return groups
    }()
}
