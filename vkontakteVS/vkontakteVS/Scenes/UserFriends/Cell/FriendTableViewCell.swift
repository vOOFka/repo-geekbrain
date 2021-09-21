//
//  FriendTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak private var friendImage: UIImageView! {
        didSet {
            friendImage.layer.cornerRadius = friendImage.frame.size.height / 2
            friendImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak private var friendName: UILabel!
    @IBOutlet weak private var cityName: UILabel!
    //MARK: - Properties
    private struct Properties {
        static let realmService: RealmService = RealmServiceImplimentation()
        static var currentFriend = Friend()
    }
    //MARK: - Functions
    func configuration(currentFriend: RealmFriend) {
        let tapRecognazer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        friendName.text = currentFriend.fullName
        cityName.text = currentFriend.cityName

        friendImage.isUserInteractionEnabled = true
        friendImage.addGestureRecognizer(tapRecognazer)
        
        guard let avatarFromDB = currentFriend.imageAvatar else {
            guard let url = currentFriend.urlAvatar else { return }
            print("Загрузка из сети")
            friendImage.kf.setImage(with: URL(string: url), completionHandler: { [weak self] result in
                switch result {
                case .success(let image):
                    let image = image.image as UIImage
                    self?.pushToRealmDB(currentFriend: currentFriend, image: image)
                case .failure(let error):
                    print(error)
                }
            })
            return
        }
        print("Загрузка из БД")
        friendImage.image = UIImage(data: avatarFromDB)
    }
    //Загрузка в БД
    fileprivate func pushToRealmDB(currentFriend: RealmFriend, image: UIImage) {
        do {
            //Первый метод
//            let friend = RealmFriend()
//            friend.id = currentFriend.id
//            friend.firstName = currentFriend.firstName
//            friend.lastName = currentFriend.lastName
//            friend.nickName = currentFriend.nickName
//            friend.deactivated = currentFriend.deactivated
//            friend.isClosed = currentFriend.isClosed
//            friend.canAccessClosed = currentFriend.canAccessClosed
//            friend.cityName = currentFriend.cityName
//            friend.urlAvatar = currentFriend.urlAvatar
//            friend.imageAvatar = image.jpegData(compressionQuality: 80.0)
//            let saveToDB = try Properties.realmService.update(friend.self) //update(friend)
//            print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
            //Второй метод
            let realm = try Realm()
            let allItems = realm.objects(RealmFriend.self).first(where: { $0.id == currentFriend.id })
            let avatar = image.jpegData(compressionQuality: 80.0)
            try! realm.write {
                allItems!.setValue(avatar, forKey: "imageAvatar")
            }
            //Третий метод
//            let friend = currentFriend
//            let existItem = try Properties.realmService.get(RealmFriend.self, primaryKey: currentFriend.id)
//            if (existItem != nil) && (existItem?.imageAvatar) != nil && friend.imageAvatar == existItem?.imageAvatar {
//                friend.imageAvatar = existItem!.imageAvatar
//            } else {
//                friend.imageAvatar = image.jpegData(compressionQuality: 80.0)                
//            }
//            _ = try Properties.realmService.update(friend)
        } catch (let error) {
            print(error)
        }
    }
}

extension UITableViewCell {
    @objc func tapOnAvatar(tap: UITapGestureRecognizer){
        let tapImageView = tap.view as! UIImageView
        tapImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 10,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        tapImageView.transform = CGAffineTransform.identity
                       },
                       completion: nil)
    }
}
