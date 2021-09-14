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
    @Persisted var id: Int = 0
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
    }
}
