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
    let showFriendPhotoFullScreenVC = "FriendPhotoFullScreen"
    var currentFriend: Friend?
    var selectedImage: UIImage!
    
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
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotosCollectionViewCell else {
            fatalError("Message: Error in dequeue PhotosCollectionViewCell")
        }
        
        cell.photoImageView.image = currentFriend?.photos[indexPath.row].photo

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = currentFriend?.photos[indexPath.row].photo
        performSegue(withIdentifier: showFriendPhotoFullScreenVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showFriendPhotoFullScreenVC {
            guard let fullScreenVC = segue.destination as? FriendPhotoFullScreen else {
                fatalError("Message: prepare for FriendPhotoFullScreen")
            }
            fullScreenVC.image = selectedImage
        }
    }

}