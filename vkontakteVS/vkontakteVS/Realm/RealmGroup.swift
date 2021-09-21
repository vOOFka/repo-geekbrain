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
    @Persisted var urlAvatar: String?
    @Persisted var imageAvatar: Data?

    convenience init(_ groupModel: Group) {
        self.init()
        self.id = groupModel.id
        self.name = groupModel.name
        self.isMember = groupModel.isMember
        self.urlAvatar = groupModel.urlPhoto
        self.imageAvatar = groupModel.imageAvatar?.jpegData(compressionQuality: 80.0)
    }
}
