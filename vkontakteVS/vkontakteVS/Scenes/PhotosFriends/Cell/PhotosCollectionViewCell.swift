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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesControl: LikesControl!
    //MARK: - Properties
    private struct Properties {
        static let realmService: RealmService = RealmServiceImplimentation()
        static var currentPhoto = Photo()
    }
    //MARK: - Functions
    func configuration(currentPhoto: RealmPhoto) {
        likesControl.setupLikesUI(countLikes: currentPhoto.likes ?? 0)
        guard let photoFromDB = currentPhoto.image else {
            //Choice size download photo
            let size = sizeTypeRealmEnum.mid
            guard let url = currentPhoto.sizes.first(where: { $0.type == size })?.urlPhoto else { return }
            print("Загрузка из сети")
            photoImageView.kf.setImage(with: URL(string: url), completionHandler: { [weak self] result in
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
        photoImageView.image = UIImage(data: photoFromDB)
    }
    //Загрузка в БД
    fileprivate func pushToRealmDB(currentPhoto: RealmPhoto, image: UIImage) {
        do {
            Properties.currentPhoto.id = currentPhoto.id
            Properties.currentPhoto.ownerId = currentPhoto.ownerId
            Properties.currentPhoto.albumId = currentPhoto.albumId
            Properties.currentPhoto.date = currentPhoto.date
            Properties.currentPhoto.likes = currentPhoto.likes
            Properties.currentPhoto.reposts = currentPhoto.reposts
            Properties.currentPhoto.image = image
            let saveToDB = try Properties.realmService.update(RealmPhoto(Properties.currentPhoto))
            print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
        } catch (let error) {
            print(error)
        }
    }
}
