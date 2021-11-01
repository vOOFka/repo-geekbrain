//
//  Photos.swift
//  vkontakteVS
//
//  Created by Home on 26.07.2021.
//

import UIKit

class Photos: Decodable {
    let items: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    enum ItemsKeys: String, CodingKey {
        case items
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let itemsContainer = try container.nestedContainer(keyedBy: ItemsKeys.self, forKey: .response)
        self.items = try itemsContainer.decode([Photo].self, forKey: .items)
    }
}

class Photo: Decodable {
    var id: Int = 0
    var albumId: Int = 0
    var ownerId: Int = 0
    var text: String?
    var date: Int = 0
    var sizes = [sizePhoto]()
    var likes: Int? = 0
    var reposts: Int? = 0
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case text
        case date
        case sizes
        case likes
        case reposts
    }
    enum LikesKeys: String, CodingKey {
        case likes = "count"
    }
    enum RepostsKeys: String, CodingKey {
        case reposts = "count"
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        self.text = try? container.decode(String.self, forKey: .text)
        self.date = try container.decode(Int.self, forKey: .date)
        self.sizes = try container.decode([sizePhoto].self, forKey: .sizes)
        //Likes
        let likesContainer = try? container.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = try likesContainer?.decode(Int.self, forKey: .likes)
        //Reposts
        let repostsContainer = try? container.nestedContainer(keyedBy: RepostsKeys.self, forKey: .reposts)
        self.reposts = try repostsContainer?.decode(Int.self, forKey: .reposts)
    }
}

enum sizeType: String, Decodable {
    case small = "s"
    case mid = "m"
    case max = "x"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case l = "l"
    case xmax = "y"
    case xxmax = "z"
    case xxxmax = "w"
}

class sizePhoto: Decodable {
    var height: Int = 0
    var width: Int = 0
    var type = sizeType.small
    var urlPhoto: String = ""
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case type
        case urlPhoto = "url"
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.height = try container.decode(Int.self, forKey: .height)
        self.width = try container.decode(Int.self, forKey: .width)
        self.type = sizeType(rawValue: try container.decode(sizeType.RawValue.self, forKey: .type)) ?? sizeType.max
        self.urlPhoto = try container.decode(String.self, forKey: .urlPhoto)
    }
}
