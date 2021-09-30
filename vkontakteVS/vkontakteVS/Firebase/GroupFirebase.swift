//
//  GroupFirebase.swift
//  vkontakteVS
//
//  Created by Home on 01.10.2021.
//

import UIKit
import Firebase

class GroupFirebase {
    var id: Int
    var name: String
    let ref: DatabaseReference?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String : Any],
            let id = value["id"] as? Int,
            let name = value["name"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "name": name
        ]
    }
    
}
