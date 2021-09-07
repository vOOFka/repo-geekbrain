//
//  Friends.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit

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
    var fullName: String {
        var fio = [String]()
        fio.append(firstName)
        fio.append(nickName ?? "")
        fio.append(lastName)
        return fio.filter({ !$0.isEmpty }).joined(separator: " ")
    }
    var category: String { return String(fullName.first ?? " ") }
    var firstName: String = ""
    var lastName: String = ""
    var nickName: String?
    var deactivated: String?
    var isClosed: Bool?
    var canAccessClosed: Bool?
    var cityName: String?
    var urlAvatar: String?
    var imageAvatar: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case nickName = "nickname"
        case deactivated
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case cityName = "city"
        case urlAvatar = "photo_100" //"photo_200_orig"
    }
    
    enum CityKeys: String, CodingKey {
        case city = "title"
    }
    init() {}    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.nickName = try? container.decode(String.self, forKey: .nickName)
        self.deactivated = try? container.decode(String.self, forKey: .deactivated)
        self.isClosed = try? container.decode(Bool.self, forKey: .isClosed)
        self.canAccessClosed = try? container.decode(Bool.self, forKey: .canAccessClosed)
        self.urlAvatar = try? container.decode(String.self, forKey: .urlAvatar)
        //City
        let cityContainer = try? container.nestedContainer(keyedBy: CityKeys.self, forKey: .cityName)
        self.cityName = try? cityContainer?.decode(String.self, forKey: .city)
    }
}
