//
//  Friends.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit

//class FriendsResponse: Decodable {
//    let response: Friends
//}

class Friends: Decodable {
    let items: [Friend]
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    enum ItemsKeys: String, CodingKey {
        case items
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let itemsContainer = try container.nestedContainer(keyedBy: ItemsKeys.self, forKey: .response)
        self.items = try itemsContainer.decode([Friend].self, forKey: .items)
        
    }
}

class Friend: Decodable {
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var nickName: String?
    var deactivated: String?
    var isClosed: Bool?
    var canAccessClosed: Bool?
    var cityName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case nickName = "nickname"
        case deactivated
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case cityName = "city"
    }
    
    enum CityKeys: String, CodingKey {
        case city = "title"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.nickName = try? container.decode(String.self, forKey: .nickName)
        self.deactivated = try? container.decode(String.self, forKey: .deactivated)
        self.isClosed = try? container.decode(Bool.self, forKey: .isClosed)
        self.canAccessClosed = try? container.decode(Bool.self, forKey: .canAccessClosed)
        
        //City
        let cityContainer = try? container.nestedContainer(keyedBy: CityKeys.self, forKey: .cityName)
        self.cityName = try? cityContainer?.decode(String.self, forKey: .city)
    }
}

//struct FriendsResponseExtract: Decodable {
//    let response: FriendsResponse
//}
//
//struct FriendsResponse: Decodable {
//    let items: [Friend]
//}
//
//struct Friend: Decodable {
//    let id: Int
//    let firstName: String
//    let lastName: String
//    let nickName: String?
//    let deactivated: String?
//    let isClosed: Bool?
//    let canAccessClosed: Bool?
//    let city: City?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case nickName = "nickname"
//        case deactivated
//        case isClosed = "is_closed"
//        case canAccessClosed = "can_access_closed"
//        case city
//    }
//}
//
//struct City: Decodable {
//    let id: Int
//    let title: String
//}

//struct Friend {
//    let name: String
//    let image: UIImage?
//    let photos: [Photos]
//    private static let friendsNameArray = ["Иванов Иван","Петров Петр","Ледова Катя","Медведева Мария","Илья Муромец","Алеша Попович","Борисов Борис","Матвей Смирнов","Гендальф Розовый","Брюс Уэйн","Умка Белый","Мария Чернышева","Богдан Яковлев","Артём Виноградов"]
//}
//
//extension Friend {
//    static let allFriends: [Friend] = {
//        var friends = [Friend]()
//        for friend in friendsNameArray {
//            let photos = Photos.getRandomPhotos()
//            friends.append(Friend(name: friend, image: UIImage(named: friend), photos: photos))
//        }
//        return friends
//    }()
//
//    static func lettersFriends() -> [String] {
//        var array = friendsNameArray.map({ String($0.first!) })
//        array = Array(Set(array))
//        return array.sorted()
//    }
//}
