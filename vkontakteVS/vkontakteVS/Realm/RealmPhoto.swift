//
//  RealmPhoto.swift
//  vkontakteVS
//
//  Created by Home on 14.09.2021.
//

import Foundation
import UIKit
import RealmSwift

class RealmPhoto: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var albumId: Int = 0
    @Persisted var ownerId: Int = 0
    @Persisted var text: String?
    @Persisted var date: Int = 0
    @Persisted var sizes = List<RealmSizePhoto>()
    @Persisted var likes: Int? = 0
    @Persisted var likeState: Bool = false
    @Persisted var reposts: Int? = 0
    
    convenience init(_ photoModel: Photo) {
        self.init()
        self.id = photoModel.id
        self.albumId = photoModel.albumId
        self.ownerId = photoModel.ownerId
        self.text = photoModel.text
        self.date = photoModel.date
        self.sizes = {
            let sizeList = List<RealmSizePhoto>()
            for size in photoModel.sizes {
                let sizeObj = RealmSizePhoto.init(size)
                sizeList.append(sizeObj)
            }
            return sizeList
        }()
        self.likes = photoModel.likes
        self.reposts = photoModel.reposts
       // self.image = photoModel.image?.jpegData(compressionQuality: 80.0)
    }
}

class RealmSizePhoto: Object {
    @Persisted var height: Int = 0
    @Persisted var width: Int = 0
    @Persisted var type: sizeTypeRealmEnum?
    @Persisted var urlPhoto: String = ""
    @Persisted var image: Data?
    
    convenience init(_ sizePhotoModel: sizePhoto) {
        self.init()
        self.height = sizePhotoModel.height
        self.width = sizePhotoModel.width
        self.type = sizeTypeRealmEnum.init(rawValue: sizePhotoModel.type.rawValue)
        self.urlPhoto = sizePhotoModel.urlPhoto
        self.image = sizePhotoModel.image?.jpegData(compressionQuality: 80.0)
    }
}


enum sizeTypeRealmEnum: String, PersistableEnum {
        case small = "s"
        case mid = "m"
        case max = "x"
        case o = "o"
        case p = "p"
        case q = "q"
        case r = "r"
        case xmax = "y"
        case xxmax = "z"
        case xxxmax = "w"
}
