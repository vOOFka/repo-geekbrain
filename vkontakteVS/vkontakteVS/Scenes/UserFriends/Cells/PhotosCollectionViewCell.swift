//
//  PhotosCollectionViewCell.swift
//  vkontakteVS
//
//  Created by Home on 26.07.2021.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
 
    func setup(currentFriend: Friend, index: IndexPath) {
        photoImageView.image = currentFriend.photos[index.row]
    }
}
