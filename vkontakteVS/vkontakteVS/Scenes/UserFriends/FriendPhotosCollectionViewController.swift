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

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFriend?.photos.count ?? 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotosCollectionViewCell else {
            fatalError("Message: Error in dequeue PhotosCollectionViewCell")
        }
        
        cell.photoImageView.image = currentFriend?.photos[indexPath.row]

        return cell
    }

}
