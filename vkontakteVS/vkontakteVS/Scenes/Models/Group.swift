//
//  Group.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit

struct Group {
    let name: String
    let image: UIImage?
    
    private static let userGroupsNames = ["Автолюбители","Гринпис"]
    private static let aveliableGroupsNames = ["Библиофилы", "Программисты IOS", "Готовим вкусно!"]
    
    static let userGroups: [Group] = {
        var groups = [Group]()
        
        for group in userGroupsNames {
            groups.append(Group(name: group, image: UIImage(named: group)))
        }
        return groups
    }()
    
    static let aveliableGroups: [Group] = {
        var groups = [Group]()
        
        for group in aveliableGroupsNames {
            groups.append(Group(name: group, image: UIImage(named: group)))
        }
        return groups
    }()
}
