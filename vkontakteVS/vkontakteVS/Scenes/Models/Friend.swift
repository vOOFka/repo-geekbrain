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
    let photos: [Photos]
    private static let friendsNameArray = ["Иванов Иван","Петров Петр","Ледова Катя","Медведева Мария","Илья Муромец","Алеша Попович","Борисов Борис","Матвей Смирнов","Гендальф Розовый","Брюс Уэйн","Умка Белый","Мария Чернышева","Богдан Яковлев","Артём Виноградов"]
}

extension Friend {
  
    static let allFriends: [Friend] = {
        var friends = [Friend]()
        for friend in friendsNameArray {
            let photos = Photos.getRandomPhotos()
            friends.append(Friend(name: friend, image: UIImage(named: friend), photos: photos))
        }
        return friends
    }()
   
    static func lettersFriends() -> [String] {
        var array = friendsNameArray.map({ String($0.first!) })
        array = Array(Set(array))
        return array.sorted()
    }
}