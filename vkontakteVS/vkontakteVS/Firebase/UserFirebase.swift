//
//  UserFirebase.swift
//  vkontakteVS
//
//  Created by Home on 01.10.2021.
//

import UIKit
import Firebase

class UserFirebase {
    var userId: Int
    var userName: String
    let ref: DatabaseReference?
    
    init(userId: Int, userName: String) {
        self.userId = userId
        self.userName = userName
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String : Any],
            let userId = value["userId"] as? Int,
            let userName = value["userName"] as? String else { return nil }
        
        self.userId = userId
        self.userName = userName
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "userId": userId,
            "userName": userName
        ]
    }
    
}
