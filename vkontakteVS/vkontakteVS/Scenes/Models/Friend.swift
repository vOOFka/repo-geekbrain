//
//  Friend.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit

struct Friend {
    let name: String
    let image: UIImage?
    let photos: [UIImage]
    
    static var friendsNameArray = ["Иванов Иван","Петров Петр","Ледова Катя","Медведева Мария","Илья Муромец","Алеша Попович","Борисов Борис"]
    
    static func getFriends() -> [Friend] {
        
        var friends = [Friend]()
        
        for friend in friendsNameArray {
            let photos = Photos.getPhotos()
            friends.append(Friend(name: friend, image: UIImage(named: friend), photos: photos ))
        }
        return friends
    }
}
