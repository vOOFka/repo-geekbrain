//
//  NewsFeed.swift
//  vkontakteVS
//
//  Created by Admin on 06.08.2021.
//

import UIKit

class NewsFeed: Decodable {
    let items: [News]
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    enum ItemsKeys: String, CodingKey {
        case items
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let itemsContainer = try container.nestedContainer(keyedBy: ItemsKeys.self, forKey: .response)
        self.items = try itemsContainer.decode([News].self, forKey: .items)
    }
}

class News: Decodable {
    var id: Int = 0
    var date: Int = 0
    var text: String = ""
    var attachments: [Attachments]?
  //  var size: NewsCellSizes? {
        //let showAllText = newsWithFullText.contains { (newsId) -> Bool in return newsId == id }
  //      return NewsCellSizeCalculator().sizes(newsText: attachments?[0].description, newsImage: nil, showAllText: false)
  //  }
    
    enum CodingKeys: String, CodingKey {
        case id,date,text,attachments
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.date = try container.decode(Int.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .text)
        self.attachments = try? container.decode([Attachments].self, forKey: .attachments)
    }
}

class Attachments: Decodable {
    var type: String = ""
    var title: String = ""
    var description: String = ""
    var photo: Photo?
    enum CodingKeys: String, CodingKey {
        case type,title,description,photo
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.photo = try? container.decode(Photo.self, forKey: .photo)
    }
}

//struct News {
//    let newsId: Int
//    let groupId: Int
//    let date: Date
//    let text: String?
//    let image: UIImage?
//    let comments: Int?
//    let likes: Int?
//    let repost: Int?
//    let views: Int?
//}
//
//extension News {
//    static let someNews = [News(newsId: 0, groupId: 0,
//                                date: Date(),
//                                text:"""
//Участники проекта «Спектр-РГ» объявили о важном событии: орбитальная обсерватория подтвердила модель происхождения Вселенной в результате Большого взрыва. Участники проекта «Спектр-РГ» объявили о важном событии: орбитальная обсерватория подтвердила модель происхождения Вселенной в результате Большого взрыва.
//""",
//                                image: UIImage(named: "news_001"),
//                                comments: 11,
//                                likes: 12,
//                                repost: 16,
//                                views: 123),
//                           News(newsId: 1, groupId: 2,
//                                date: Date(),
//                                text: nil,
////                                text:"""
////Компания AMD начала розничные продажи Ryzen 5000G — 7-нм гибридных настольных процессоров (APU) нового поколения. Они сочетают в себе процессорные ядра с архитектурой Zen 3 и встроенный графический процессор Vega. На данный момент было выпущено две модели. Старший чип Ryzen 7 5700G обладает восемью ядрами и шестнадцатью потоками, работает с базовой частотой 3,8 ГГц, а максимальная частота при динамическом разгоне достигает 4,6 ГГц. Имеется 16 Мбайт кеша третьего уровня, а графический процессор насчитывает 512 потоковых процессор и работает с частотой до 2000 МГц. Рекомендованная цена данного процессора составляет $359.
////""",
//                                image: UIImage(named: "news_002"),
//                                comments: 3,
//                                likes: nil,
//                                repost: 1,
//                                views: 876),
//                           News(newsId: 2, groupId: 3,
//                                date: Date(),
//                                text:"""
//Сегодня в мире смартфонов наметилось очень суровое расслоение: между условным средним классом и флагманами пролегает финансовая пропасть в 40-50 тысяч рублей, и в этой пропасти нет почти никого — только подешевевшие прошлогодние модели вроде Samsung Galaxy S20 FE или Huawei P40 и редкие представители вымирающего вида «убийц флагманов» вроде OnePlus 9/9R, которые приходится приобретать «серым» образом. Ну или ASUS Zenfone 8, который все-таки дороже и ориентируется скорее на особую аудиторию любителей компактных смартфонов. Xiaomi Mi, некогда бывшие сюзеренами этих земель, окончательно приклеились к флагманским позициям с соответствующей ценой — в официальной рознице Xiaomi Mi 11 стоит 86 тысяч рублей.
//""",
//                                image: nil,
//                                comments: 6,
//                                likes: 9,
//                                repost: 3,
//                                views: 35),
//                           News(newsId: 3, groupId: 4,
//                                date: Date(),
//                                text:"""
//Как и ожидалось, в блокчейн-сети Ethereum вышло обновление London, которое принесёт с собой ряд важных изменений, в том числе переработанный механизм начисления комиссий за проводимые транзакции. На фоне этой новости курс второй по популярности криптовалюты мира начал расти и на момент написания этой заметки за один Ethereum давали около $2790.
//""",
//                                image: UIImage(named: "news_004"),
//                                comments: 16,
//                                likes: 59,
//                                repost: 63,
//                                views: 756),
//                           News(newsId: 4, groupId: 4,
//                                date: Date(),
//                                text:"""
//Власти Детройта (США) совместно с Ford и Bosch готовятся открыть «лабораторию» Smart Parking Lab на базе принадлежащего компании Bedrock гаража-полигона. В реальных условиях автопроизводители смогут тестировать и совершенствовать технологии, используемые для автономной парковки.
//""",
//                                image: UIImage(named: "news_005"),
//                                comments: 1,
//                                likes: 8,
//                                repost: 7,
//                                views: 78)
//    ]
//}
//
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
