//
//  RalmFriend.swift
//  vkontakteVS
//
//  Created by Home on 13.09.2021.
//

import Foundation
import RealmSwift

class RealmFriend: Object {
    @Persisted var id: Int = 0
    @Persisted var fullName: String
//        = { () -> <#Result#> in
//     var fio = [String]()
//        fio.append(firstName)
//        fio.append(nickName ?? "")
//        fio.append(lastName)
//        return fio.filter({ !$0.isEmpty }).joined(separator: " ")
//    }
 //   @Persisted var category: String { return String(fullName.first ?? " ") }
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var nickName: String?
    @Persisted var deactivated: String?
    @Persisted var isClosed: Bool?
    @Persisted var canAccessClosed: Bool?
    @Persisted var cityName: String?
    @Persisted var urlAvatar: String?
    
//    convenience override init(_ model: Friend) {
//        self.init(model)
        
//    }
}
