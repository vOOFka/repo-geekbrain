//
//  FriendsCat.swift
//  vkontakteVS
//
//  Created by Home on 02.08.2021.
//

import UIKit

struct FriendsCategory {
    let categoryFriendName: String
    var friends: [Friend]
}

extension FriendsCategory {
    static let allCategorys: [FriendsCategory] = {
        let categorys = Friend.lettersFriends()
        var friendsCategory = [FriendsCategory]()
        let allFriends = Friend.allFriends
        
        for category in categorys {
            var newCategory = FriendsCategory(categoryFriendName: category, friends: [Friend]())
            for friend in allFriends {
                if category == String(friend.name.first!) {
                    newCategory.friends.append(friend)
                }
            }
            friendsCategory.append(newCategory)
        }
        return friendsCategory
    }()
}
