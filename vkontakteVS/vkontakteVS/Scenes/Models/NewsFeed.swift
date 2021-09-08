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
  //  var size: NewsCellSizes? {
        //let showAllText = newsWithFullText.contains { (newsId) -> Bool in return newsId == id }
  //      return NewsCellSizeCalculator().sizes(newsText: attachments?[0].description, newsImage: nil, showAllText: false)
  //  }
    
    enum CodingKeys: String, CodingKey {
        case id = "post_id", sourceId = "source_id"
        case date,text,attachments
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)
        self.date = try container.decode(Int.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .text)
        self.attachments = try? container.decode([Attachments].self, forKey: .attachments)
    }
}

class Attachments: Decodable {
    var type: String = ""
    var title: String? = ""
    var description: String? = ""
    var photo: Photo?
    enum CodingKeys: String, CodingKey {
        case type,title,description,photo
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.title = try? container.decode(String.self, forKey: .title)
        self.description = try? container.decode(String.self, forKey: .description)
        self.photo = try? container.decode(Photo.self, forKey: .photo)
    }
}

//struct UserActualNews: NewsTableViewCellModel {
//    var id: Int
//    var date: String
//    var text: String?
//    var image: UIImage?
//    var likes: String
//    var comments: String
//    var repost: String
//    var views: String
//    var size: NewsCellSizes
//
//    static func getNewsFromUserGroups(with newsWithFullText: [Int]) -> [NewsTableViewCellModel] {
//        let actualUserNewsArray = [NewsTableViewCellModel]()
//        let someNews = News.someNews
//
//        for news in someNews {
//            let showAllText = newsWithFullText.contains { (newsId) -> Bool in return newsId == news.newsId }
//            let sizes = NewsCellSizeCalculator().sizes(newsText: news.text, newsImage: news.image, showAllText: showAllText)
//            let actualUserNews = UserActualNews(
//                newsId: news.newsId,
//                date:   "11 августа 2021",
//                text:   news.text ?? nil,
//                image:  news.image ?? nil,
//                likes:  String(news.likes ?? 0),
//                comments: String(news.comments ?? 0),
//                repost: String(news.repost ?? 0),
//                views:  String(news.views ?? 0),
//                size:   sizes)
//            actualUserNewsArray.append(actualUserNews)
//        }
//        return actualUserNewsArray
//    }
//}
