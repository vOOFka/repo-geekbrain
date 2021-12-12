//
//  PushFriendsToRealmOperation.swift
//  vkontakteVS
//
//  Created by Home on 03.11.2021.
//

import Foundation
import UIKit
import RealmSwift

class PushFriendsToRealmOperation<T:Decodable> : Operation {
    private let realmService: RealmService = RealmServiceImplimentation()
    
    override func main() {
        guard
            let dataAfterParsingOperation = dependencies.first(where: {$0 is DataParsingOperation<T> }) as? DataParsingOperation<T>,
            let data = dataAfterParsingOperation.outputData as? Friends
        else {
            print("Data not parsing")
            return
        }
        //Преобразование в Realm модель
        let itemsForRealm = data.items.map({ RealmFriend($0) })
        do {
            let existItems = try realmService.get(RealmFriend.self)
            for item in itemsForRealm {
                guard let existImg = existItems.first(where: { $0.id == item.id })?.imageAvatar else { break }
                item.imageAvatar = existImg
            }
            let saveToDB = try realmService.update(itemsForRealm)
            print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")            
        } catch (let error) {
            print(error)
        }
    }
}
