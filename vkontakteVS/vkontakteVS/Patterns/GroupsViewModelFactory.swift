//
//  GroupsViewModelFactory.swift
//  vkontakteVS
//
//  Created by Home on 16.12.2021.
//

import Kingfisher
import RealmSwift
import UIKit

class GroupsViewModelFactory {
    private let networkService = NetworkServiceImplimentation()
    
    func cunstructViewModels(from groups: [Group]) -> [GroupsViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from group: Group) -> GroupsViewModel? {
        let id = group.id
        let name = group.name
        var imgData = Data()
      //  let imgView = UIImageView()
        
        if group.imageAvatar != nil {
            imgData = (group.imageAvatar?.jpegData(compressionQuality: 80.0))!
        } else if group.urlPhoto != nil {
            self.networkService.getImageFromWeb(imageURL: group.urlPhoto!, completion: { imageAvatar in
                imgData = imageAvatar })
        }
        return GroupsViewModel(id: id, name: name, imageAvatar: imgData)
    }
    
    //Загрузка в БД
    private func pushToRealmDB(currentGroup: RealmGroup, image: UIImage) {
        do {
            let realm = try Realm()
            guard let allItems = realm.objects(RealmGroup.self).first(where: { $0.id == currentGroup.id }) else { return }
            let avatar = image.jpegData(compressionQuality: 80.0)
            try realm.write {
                allItems.setValue(avatar, forKey: "imageAvatar")
            }
        } catch (let error) {
            print(error)
        }
    }
}
