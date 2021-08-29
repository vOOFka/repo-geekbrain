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
    private let reuseIdentifier = "PhotosCollectionViewCell"
    private let showFriendPhotoFullScreenVC = "FriendPhotoFullScreen"
    var currentFriend: Friend?
    private var selectedImage: (UIImage?, Int)?
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for custom animation transition
        //self.navigationController?.delegate = self       

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Show photos friend from VK in console JSON
        networkService.getPhotos(friendId: "671822833")
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFriend?.photos.count ?? 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PhotosCollectionViewCell.self, for: indexPath)
        cell.photoImageView.image = currentFriend?.photos[indexPath.row].photo
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = (currentFriend?.photos[indexPath.row].photo, indexPath.row)
        performSegue(withIdentifier: showFriendPhotoFullScreenVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showFriendPhotoFullScreenVC {
            guard let fullScreenVC = segue.destination as? FriendPhotoFullScreen else {
                fatalError("Message: prepare for FriendPhotoFullScreen")
            }
            fullScreenVC.image = selectedImage
            fullScreenVC.currentFriend = currentFriend
        }
    }

}
