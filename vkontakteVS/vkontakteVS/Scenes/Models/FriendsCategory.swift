//
//  FriendsCat.swift
//  vkontakteVS
//
//  Created by Home on 02.08.2021.
//

import UIKit

class FriendsCategory {
    let category: String
    var friends: [FriendViewModel]
    
    init(category: String ,array friends: [FriendViewModel]) {
        self.category = category
        self.friends = friends
    }
}
