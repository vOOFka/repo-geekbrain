//
//  FriendsCat.swift
//  vkontakteVS
//
//  Created by Home on 02.08.2021.
//

import UIKit

class FriendsCategory {
    let category: String
    var friends: [Friend]
    
    init(category: String ,array friends: [Friend]) {
        self.category = category
        self.friends = friends
    }
}

//struct FriendsCategory {
//    let categoryFriendName: String
//    var friends: [Friend]
//}
//
//extension FriendsCategory {
//    static let allCategorys: [FriendsCategory] = {
//        let categorys = Friend.lettersFriends()
//        var friendsCategorys = [FriendsCategory]()
//        let allFriends = Friend.allFriends
//        
//        for category in categorys {
//            var newCategory = FriendsCategory(categoryFriendName: category, friends: [Friend]())
//            for friend in allFriends {
//                if category == String(friend.name.first!) {
//                    newCategory.friends.append(friend)
//                }
//            }
//            friendsCategorys.append(newCategory)
//        }
//        return friendsCategorys
//    }()
//}
