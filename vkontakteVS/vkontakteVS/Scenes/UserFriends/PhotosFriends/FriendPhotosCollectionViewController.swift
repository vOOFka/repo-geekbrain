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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for custom animation transition
        self.navigationController?.delegate = self
    }

    // MARK: UICollectionViewDataSource
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

extension FriendPhotosCollectionViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return AnimationController(animationType: .present)
        case .pop:
            return AnimationController(animationType: .dismiss)
        case .none:
            return nil
        @unknown default:
            return nil
        }
    }
}
