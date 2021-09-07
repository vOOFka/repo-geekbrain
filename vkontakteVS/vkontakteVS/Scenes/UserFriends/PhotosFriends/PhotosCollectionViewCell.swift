//
//  PhotosCollectionViewCell.swift
//  vkontakteVS
//
//  Created by Home on 26.07.2021.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesControl: LikesControl!
    //MARK: - Prefirence
    private let networkService = NetworkServiceInplimentation()
    //MARK: - Functions
    func configuration(currentPhoto: Photo) {
        likesControl.setupLikesUI(countLikes: currentPhoto.likes)
        DispatchQueue.main.async {
            //Choice size download photo
            let size = sizeType.mid
            let url = currentPhoto.sizes.first(where: { $0.type == size })!.urlPhoto
            self.networkService.getImageFromWeb(imageURL: url, completion: { [weak self] photo in self?.photoImageView.image = photo })
        }
    }
}
