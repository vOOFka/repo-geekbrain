//
//  FriendPhotosCollectionViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit
import RealmSwift

class FriendPhotosCollectionViewController: UICollectionViewController {
        
    //MARK: Outlets
    @IBOutlet private var friendPhotosCollectionView: UICollectionView!
    
    //MARK: Properties
    private struct Properties {
        static let networkService = NetworkServiceImplimentation()
        static let realmService: RealmService = RealmServiceImplimentation()
        static var photosList: Results<RealmPhoto>!
        static let showFriendPhotoFullScreenVC = "FriendPhotoFullScreen"
    }
    //MARK: Public properties
    public var currentFriend: Int = 0
    //    private let reuseIdentifier = "PhotosCollectionViewCell"
    //    private var photosItems = [Photo]()
    //    private var selectedImage: (Photo?, Int)?
    //    private let networkService = NetworkServiceImplimentation()
    //    private let realmService: RealmService = RealmServiceImplimentation()
   
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Properties.showFriendPhotoFullScreenVC {
//            guard let fullScreenVC = segue.destination as? FriendPhotoFullScreen else {
//                fatalError("Message: prepare for FriendPhotoFullScreen")
//            }
//         //   if selectedImage != nil {
//             //   fullScreenVC.configuration(selectPhoto: selectedImage!, anotherPhoto: photosItems)
//         //   }
//        }
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //for custom animation transition
        //self.navigationController?.delegate = self
        //Get photos from VK API
        updatePhotosFromVKAPI()
        //Pull data photos from RealmDB
        pullFromRealm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var count: Int = 0
//        if !Properties.photosList.isEmpty { count = Properties.photosList.count }
        return Properties.photosList.count
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PhotosCollectionViewCell.self, for: indexPath)
        if !Properties.photosList.isEmpty {
            let photo = Properties.photosList[indexPath.row]
            cell.configuration(currentPhoto: photo)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     //   selectedImage = (Properties.photosList[indexPath.row], indexPath.row)
        performSegue(withIdentifier: Properties.showFriendPhotoFullScreenVC, sender: nil)
    }
}
//MARK: - Functions
extension FriendPhotosCollectionViewController {
    fileprivate func updatePhotosFromVKAPI() {
        Properties.networkService.getPhotosAll(friendId: currentFriend, completion: { [weak self] photosItems in
            guard let self = self else { return }
            self.pushToRealm(photosItems: photosItems)
        })
    }
    
    //Загрузка данных в БД Realm
    fileprivate func pushToRealm(photosItems: Photos?) {
        guard let photosItems = photosItems?.items else { return }
        //Преобразование в Realm модель
        let photosItemsRealm = photosItems.map({ RealmPhoto($0, image: nil) })
        //Загрузка
        do {
            //let saveToDB = try realmService.save(photosItemsRealm)
            let saveToDB = try Properties.realmService.update(photosItemsRealm)
            print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
        } catch (let error) {
            print(error)
        }
    }
    
    //Получение данных из БД
    fileprivate func pullFromRealm() {
        do {
            Properties.photosList = try Properties.realmService.get(RealmPhoto.self)
        } catch (let error) {
            print(error)
        }
        collectionView.reloadData()
    }
}
