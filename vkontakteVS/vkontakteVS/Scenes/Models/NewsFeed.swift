//
//  NewsFeed.swift
//  vkontakteVS
//
//  Created by Admin on 06.08.2021.
//

import UIKit

class NewsFeed: Decodable {
    var items: [News] = []
    var groups: [Group] = []
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    enum ItemsKeys: String, CodingKey {
        case items, groups
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let itemsContainer = try container.nestedContainer(keyedBy: ItemsKeys.self, forKey: .response)
        self.items = try itemsContainer.decode([News].self, forKey: .items)
        self.groups = try itemsContainer.decode([Group].self, forKey: .groups)
    }
}

class News: Decodable {
    var id: Int = 0
    var sourceId: Int = 0
    var date: Int = 0
    var text: String = ""
    var attachments: [Attachments]?
    var countCellItems: Int = 1
    var comments: Int = 0
    var likes: Int = 0
    var reposts: Int = 0
    var views: Int = 0
    
    var sizes: NewsCellSizes? {
        //  let showAllText = newsWithFullText.contains { (newsId) -> Bool in return newsId == id }
        return NewsCellSizeCalculator().sizes(newsText: text, newsImage: nil, showAllText: false)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "post_id", sourceId = "source_id"
        case date,text,attachments,comments,likes,reposts,views
    }
    enum CommentsKeys: String, CodingKey {
        case comments = "count"
    }
    enum LikesKeys: String, CodingKey {
        case likes = "count"
    }
    enum RepostsKeys: String, CodingKey {
        case reposts = "count"
    }
    enum ViewsKeys: String, CodingKey {
        case views = "count"
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)
        self.date = try container.decode(Int.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .text)
        self.attachments = try? container.decode([Attachments].self, forKey: .attachments)
        //Comments
        let commentsContainer = try container.nestedContainer(keyedBy: CommentsKeys.self, forKey: .comments)
        self.comments = try commentsContainer.decode(Int.self, forKey: .comments)
        //Likes
        let likesContainer = try container.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = try likesContainer.decode(Int.self, forKey: .likes)
        //Reposts
        let repostsContainer = try container.nestedContainer(keyedBy: RepostsKeys.self, forKey: .reposts)
        self.reposts = try repostsContainer.decode(Int.self, forKey: .reposts)
        //Views
        let viewsContainer = try container.nestedContainer(keyedBy: ViewsKeys.self, forKey: .views)
        self.views = try viewsContainer.decode(Int.self, forKey: .views)
    }
}

class Attachments: Decodable {
    var type: String = ""
    var title: String? = ""
    var description: String? = ""
    var photo: Photo?
    enum CodingKeys: String, CodingKey {
        case type,title,description,photo,link
    }
    enum LinkKeys: String, CodingKey {
        case title,description,photo
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.title = try? container.decode(String.self, forKey: .title)
        self.description = try? container.decode(String.self, forKey: .description)
        self.photo = try? container.decode(Photo.self, forKey: .photo)
        // For Link type posts
        if self.type == "link" {
            let linkContainer = try container.nestedContainer(keyedBy: LinkKeys.self, forKey: .link)
            self.title = try? linkContainer.decode(String.self, forKey: .title)
            self.description = try? linkContainer.decode(String.self, forKey: .description)
            self.photo = try? linkContainer.decode(Photo.self, forKey: .photo)
        }
    }
}
