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
