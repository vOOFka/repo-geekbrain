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
    var currentFriend = Friend()
    private var photosItems = [Photo]()
    private var selectedImage: (Photo?, Int)?
    private let networkService = NetworkServiceImplimentation()
    private let realmService: RealmService = RealmServiceImplimentation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //for custom animation transition
        //self.navigationController?.delegate = self
        //Show friends from VK API
        updatePhotosFromVKAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func updatePhotosFromVKAPI() {
        networkService.getPhotosAll(friendId: currentFriend.id, completion: { [weak self] photosItems in
            guard let self = self else { return }
            self.photosItems = photosItems?.items ?? [Photo]()
            //Загрузка данных в БД Realm
            let photosItemsRealm = self.photosItems.map({ RealmPhoto($0) })
            do {
                let saveToDB = try self.realmService.save(photosItemsRealm)
                print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
            } catch (let error) {
                print(error)
            }
            self.collectionView.reloadData()
            })
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosItems.count
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PhotosCollectionViewCell.self, for: indexPath)
        if !photosItems.isEmpty {
            let photo = photosItems[indexPath.row]
            cell.configuration(currentPhoto: photo)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = (photosItems[indexPath.row], indexPath.row)
        performSegue(withIdentifier: showFriendPhotoFullScreenVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showFriendPhotoFullScreenVC {
            guard let fullScreenVC = segue.destination as? FriendPhotoFullScreen else {
                fatalError("Message: prepare for FriendPhotoFullScreen")
            }
            if selectedImage != nil {
                fullScreenVC.configuration(selectPhoto: selectedImage!, anotherPhoto: photosItems)
            }
        }
    }
}
