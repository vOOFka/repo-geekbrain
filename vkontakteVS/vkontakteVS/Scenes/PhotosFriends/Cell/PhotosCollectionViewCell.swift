//
//  PhotosCollectionViewCell.swift
//  vkontakteVS
//
//  Created by Home on 26.07.2021.
//

import UIKit
import Kingfisher

class PhotosCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesControl: LikesControl!
    //MARK: - Prefirence
    private let networkService = NetworkServiceImplimentation()
    //MARK: - Functions
    func configuration(currentPhoto: RealmPhoto) {
        likesControl.setupLikesUI(countLikes: currentPhoto.likes ?? 0)
        //DispatchQueue.main.async {
            //Choice size download photo
            let size = sizeType.mid
           // let url = currentPhoto.sizes.first(where: { $0.type == size })!.urlPhoto
           // photoImageView.kf.setImage(with: URL(string: url))
            //self.networkService.getImageFromWeb(imageURL: url, completion: { [weak self] photo in self?.photoImageView.image = photo })
        //}
    }
}
