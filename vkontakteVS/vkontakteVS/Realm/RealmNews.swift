//
//  RealmNews.swift
//  vkontakteVS
//
//  Created by Home on 15.09.2021.
//

import Foundation
import UIKit
import RealmSwift
    
class RealmNews: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var sourceId: Int = 0
    @Persisted var date: Int = 0
    @Persisted var text: String = ""
    @Persisted var attachments = List<RealmAttachments>()
    @Persisted var countCellItems: Int = 1
    @Persisted var comments: Int = 0
    @Persisted var likes: Int = 0
    @Persisted var reposts: Int = 0
    @Persisted var views: Int = 0
    
    convenience init(_ newsModel: News) {
        self.init()
        self.id = newsModel.id
        self.sourceId = newsModel.sourceId
        self.date = newsModel.date
        self.text = newsModel.text
        self.attachments = {
            let attachList = List<RealmAttachments>()
            guard let newsArray = newsModel.attachments else { return attachList }
            for news in newsArray {
                let attachObj = RealmAttachments.init(news)
                if (attachObj.type == "photo" || attachObj.type == "link") {
                    attachList.append(attachObj)
                }
            }
            return attachList
        }()
        self.countCellItems = newsModel.countCellItems
        self.comments = newsModel.comments
        self.likes = newsModel.likes
        self.reposts = newsModel.reposts
        self.views = newsModel.views
    }
}

class RealmAttachments: Object {
    @Persisted var type: String = ""
    @Persisted var title: String?
    @Persisted var photo: RealmPhoto?
    
    convenience init(_ attachmentsModel: Attachments) {
        self.init()
        self.type = attachmentsModel.type
        self.title = attachmentsModel.title
        self.photo = {
            guard let attachPhoto = attachmentsModel.photo else { return nil}
            let photoObj = RealmPhoto(attachPhoto)
            return photoObj
        }()
    }
}
