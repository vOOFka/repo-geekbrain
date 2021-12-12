//
//  RalmFriend.swift
//  vkontakteVS
//
//  Created by Home on 13.09.2021.
//

import Foundation
import UIKit
import RealmSwift

class RealmFriend: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var fullName: String
    @Persisted var category: String
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var nickName: String?
    @Persisted var deactivated: String?
    @Persisted var isClosed: Bool?
    @Persisted var canAccessClosed: Bool?
    @Persisted var cityName: String?
    @Persisted var urlAvatar: String?
    @Persisted var imageAvatar: Data?
    
    convenience init(_ friendModel: Friend) {
        self.init()
        self.id = friendModel.id
        self.fullName = {
            var fio = [String]()
            fio.append(friendModel.firstName)
            fio.append(friendModel.nickName ?? "")
            fio.append(friendModel.lastName)
            return fio.filter({ !$0.isEmpty }).joined(separator: " ")
        }()
        self.category =  { return String(fullName.first ?? " ") }()
        self.firstName = friendModel.firstName
        self.lastName = friendModel.lastName
        self.nickName = friendModel.nickName
        self.deactivated = friendModel.deactivated
        self.isClosed = friendModel.isClosed
        self.canAccessClosed = friendModel.canAccessClosed
        self.cityName = friendModel.cityName
        self.urlAvatar = friendModel.urlAvatar
        self.imageAvatar = friendModel.imageAvatar?.jpegData(compressionQuality: 80.0)
    }
}

class RealmFriendsCategory: Object {
    @Persisted var category: String = ""
    @Persisted var friends = List<RealmFriend>()
    
    convenience init(category: String ,array friends: [RealmFriend]) {
        self.init()
        self.category = category
        self.friends = {
            let f = List<RealmFriend>()
            friends.forEach({ f.append($0)})
            return f
        }()
    }
}
