//
//  GroupTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class GroupTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var groupImage: UIImageView! {
        didSet {
            groupImage.layer.cornerRadius = 10.0
            groupImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var groupName: UILabel!
    //MARK: - Properties
    private struct Properties {
        static let realmService: RealmService = RealmServiceImplimentation()
        static var currentGroup = Group()
    }
    //MARK: - Functions
    func configuration(currentGroup: RealmGroup) {
        let tapRecognazer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        groupName.text = currentGroup.name

        groupImage.isUserInteractionEnabled = true
        groupImage.addGestureRecognizer(tapRecognazer)
        
        guard let avatarFromDB = currentGroup.imageAvatar else {
            guard let url = currentGroup.urlAvatar else { return }
            print("Загрузка из сети")
            groupImage.kf.setImage(with: URL(string: url), completionHandler: { [weak self] result in
                switch result {
                case .success(let image):
                    let image = image.image as UIImage
                    self?.pushToRealmDB(currentGroup: currentGroup, image: image)
                case .failure(let error):
                    print(error)
                }
            })
            return
        }
        print("Загрузка из БД")
        groupImage.image = UIImage(data: avatarFromDB)
    }
    //Загрузка в БД
    fileprivate func pushToRealmDB(currentGroup: RealmGroup, image: UIImage) {
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
