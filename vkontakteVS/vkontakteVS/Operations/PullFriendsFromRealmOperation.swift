//
//  PullFriendsFromRealmOperation.swift
//  vkontakteVS
//
//  Created by Home on 04.11.2021.
//

import Foundation
import UIKit
import RealmSwift

class PullFriendsFromRealmOperation: Operation {
    private let realmService: RealmService = RealmServiceImplimentation()
    var vc: FriendsViewController
    
    init(friends controller: FriendsViewController) {
        self.vc = controller
    }
    override func main() {
        guard
            (dependencies.first(where: {$0 is PushFriendsToRealmOperation<Friends> }) as? PushFriendsToRealmOperation<Friends>) != nil
        else {
            print("Data not pushing")
            return
        }
        do {
            let dataFromRealm = try realmService.get(RealmFriend.self)
            //Получение категорий
            let friendsCategory = dataFromRealm.sorted(by: ["category", "fullName"])
            let outputFriendsCategory = Set(friendsCategory.value(forKeyPath: "category") as! [String]).sorted()            
            vc.friendsList = dataFromRealm
            vc.sectionNames = outputFriendsCategory
        } catch (let error) {
            print(error)
        }
    }
}
