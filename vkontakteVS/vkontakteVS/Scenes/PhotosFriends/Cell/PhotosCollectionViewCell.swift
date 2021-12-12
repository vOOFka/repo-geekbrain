//
//  PhotosCollectionViewCell.swift
//  vkontakteVS
//
//  Created by Home on 26.07.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class PhotosCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var likesControl: LikesControl!
    //MARK: - Properties
    private let realmService: RealmService = RealmServiceImplimentation()
    private var currentPhoto = RealmPhoto()
    //Choice size download photo
    private let size = sizeTypeRealmEnum.mid

    //MARK: - Functions
    public func configuration(currentPhoto: RealmPhoto, delegate: AnyObject) {
        self.currentPhoto = currentPhoto
        likesControl.setupLikesUI(currentPhoto: currentPhoto)
        guard let delegate = delegate as? LikesControlDelegate else { return }
        likesControl.delegate = delegate
        guard (currentPhoto.sizes.first(where: { $0.type == size })?.image) != nil else {
            guard let url = currentPhoto.sizes.first(where: { $0.type == size })?.urlPhoto else { return }
            print("Загрузка из сети")
            _ = UIImageView().kf.setImage(with: URL(string: url), completionHandler: { [weak self] result in
                switch result {
                case .success(let image):
                    let image = image.image as UIImage
                    self?.pushToRealmDB(currentPhoto: currentPhoto, image: image)
                case .failure(let error):
                    print(error)
                }
            })
            return
        }
        print("Загрузка из БД")
        do {
            let imgFromRealm = try realmService.get(RealmPhoto.self, primaryKey: currentPhoto.id)
            let imgSizeFromRealm = imgFromRealm?.sizes.first(where: { $0.type == size })
            guard let imageData = imgSizeFromRealm?.image else { return }
            photoImageView.image = UIImage(data: imageData)
        } catch (let error) {
            print(error)
        }        
    }
    //Загрузка в БД
    fileprivate func pushToRealmDB(currentPhoto: RealmPhoto, image: UIImage) {
        do {            
            let realm = try Realm()
            guard let allItems = realm.objects(RealmPhoto.self).first(where: { $0.id == currentPhoto.id }),
                  let item =  allItems.sizes.first(where: { $0.type == size }),
                  let image = image.jpegData(compressionQuality: 80.0) else { return }
            try realm.write {
                item.setValue(image, forKey: "image")
            }
        } catch (let error) {
            print(error)
        }
    }
}
