//
//  RealmGroup.swift
//  vkontakteVS
//
//  Created by Home on 14.09.2021.
//

import Foundation
import UIKit
import RealmSwift

class RealmGroup: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var isMember: Int = 1
    @Persisted var urlPhoto: String = ""
    @Persisted var imageAvatar: Data?

    convenience init(_ groupModel: Group, image: UIImage?) {
        self.init()
        self.id = groupModel.id
        self.isMember = groupModel.isMember
        self.urlPhoto = groupModel.urlPhoto
        self.imageAvatar = image?.jpegData(compressionQuality: 80.0)
    }
}
