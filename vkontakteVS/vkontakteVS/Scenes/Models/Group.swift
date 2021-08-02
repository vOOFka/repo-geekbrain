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
    
//    static var userGroupsNames = ["Автолюбители","Гринпис"]
//    static var aveliableGroupsNames = ["Библиофилы", "Программисты IOS", "Готовим вкусно!"]
    
    static func getGroups (_ arrayGroupsNames: [String]) -> [Group] {
        
        var groups = [Group]()
        
        for group in arrayGroupsNames {
            groups.append(Group(name: group, image: UIImage(named: group)))
        }
        return groups
    }
}
