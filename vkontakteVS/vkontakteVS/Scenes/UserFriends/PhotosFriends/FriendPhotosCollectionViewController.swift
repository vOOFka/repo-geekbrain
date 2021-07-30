//
//  FriendPhotosCollectionViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class FriendPhotosCollectionViewController: UICollectionViewController {
        
    //MARK: Outlets
    @IBOutlet private var friendPhotosCollectionView: UICollectionView!
    
    //MARK: Var
    let reuseIdentifier = "PhotosCollectionViewCell"
    var currentFriend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFriend?.photos.count ?? 0
    }
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: "footer", withReuseIdentifier: "", for: indexPath) as? AvatarView else { fatalError("Message: Error in dequeue PhotosCollectionViewCell")
//
//        }
//        return footer
//    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotosCollectionViewCell else {
            fatalError("Message: Error in dequeue PhotosCollectionViewCell")
        }
        
        cell.photoImageView.image = currentFriend?.photos[indexPath.row].photo

        return cell
    }

}
