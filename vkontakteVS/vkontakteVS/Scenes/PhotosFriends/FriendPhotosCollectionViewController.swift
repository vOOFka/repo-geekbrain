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
    //MARK: - Actions
    @IBAction func getDataFromWeb(_ sender: Any) {
        //Get photos from VK API
        updatePhotosFromVKAPI()
    }
    //MARK: Properties
    private struct Properties {
        static let networkService = NetworkServiceImplimentation()
        static let realmService: RealmService = RealmServiceImplimentation()
        static var photosList: Results<RealmPhoto>!
        static let showFriendPhotoFullScreenVC = "FriendPhotoFullScreen"
        static var selectedImageId: Int = 0
        //Choice size download photo
        static let size = sizeTypeRealmEnum.mid
        static var notificationToken: NotificationToken?
       // static var selectedHearts = [IndexPath : Bool]()
    }
    //MARK: Public properties
    public var currentFriend: Int = 0
   
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Properties.showFriendPhotoFullScreenVC {
            guard let fullScreenVC = segue.destination as? FriendPhotoFullScreen else {
                fatalError("Message: prepare for FriendPhotoFullScreen")
            }
            if Properties.selectedImageId != 0 {
                fullScreenVC.configuration(selectPhotoId: Properties.selectedImageId, anotherPhoto: Properties.photosList)
            }
        }
    }
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //for custom animation transition
        //self.navigationController?.delegate = self
        //Get photos from VK API
        updatePhotosFromVKAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Pull data photos from RealmDB
        pullFromRealm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Properties.notificationToken?.invalidate()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Properties.photosList?.count ?? 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PhotosCollectionViewCell.self, for: indexPath)
        if !Properties.photosList.isEmpty {
            let photo = Properties.photosList[indexPath.row]
            cell.configuration(currentPhoto: photo, delegate: self)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Properties.selectedImageId = Properties.photosList[indexPath.row].id
        performSegue(withIdentifier: Properties.showFriendPhotoFullScreenVC, sender: nil)
    }
}
//MARK: - Functions
extension FriendPhotosCollectionViewController {
    fileprivate func updatePhotosFromVKAPI() {
        Properties.networkService.getPhotosAll(friendId: currentFriend, completion: { [weak self] photosItems in
            guard let self = self else { return }
            self.pushToRealm(photosItems: photosItems)
            //Pull data photos from RealmDB
            self.pullFromRealm()
        })
    }
    
    //Загрузка данных в БД Realm
    fileprivate func pushToRealm(photosItems: Photos?) {
        guard let photosItems = photosItems?.items else { return }
        //Преобразование в Realm модель
        let photosItemsRealm = photosItems.map({ RealmPhoto($0) })
        //Загрузка
        do {
            let existItems = try Properties.realmService.get(RealmPhoto.self)
            for item in photosItemsRealm {
                guard let existImg = existItems.first(where: { $0.id == item.id })?.sizes.first(where: { $0.type == Properties.size })?.image else { break }
                item.sizes.first(where: { $0.type == Properties.size })?.image = existImg
            }
            //let saveToDB = try realmService.save(photosItemsRealm)
            let saveToDB = try Properties.realmService.update(photosItemsRealm)
            print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
        } catch (let error) {
            showError(error)
        }
    }
    //Получение данных из БД
    fileprivate func pullFromRealm() {
        do {
            let friendPredicate = NSPredicate(format: "ownerId = %d", currentFriend)
            Properties.photosList = try Properties.realmService.get(RealmPhoto.self).filter(friendPredicate)
        } catch (let error) {
            showError(error)
        }
        collectionView.reloadData()
        //Наблюдение за изменениями
        watchingForChanges()
    }
    //Наблюдение за изменениями
    fileprivate func watchingForChanges() {
        Properties.notificationToken = Properties.photosList?.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .error(let error):
                self.showError(error)
            case .initial: break
            case .update:
                self.collectionView.reloadData()
              //  self.collectionView.reloadItems(at: <#T##[IndexPath]#>)
            }
        })
    }
}

extension FriendPhotosCollectionViewController: LikesControlDelegate {
    func likeWasTap(at controlId: Int) {
        //print("Like! \(controlId)")
        do {
            guard let item = try Properties.realmService.get(RealmPhoto.self, primaryKey: controlId) else { return }
            let realm = try Realm()
            try? realm.write {
                item.likeState = !item.likeState
                if item.likeState == true {
                    item.likes! += 1
                } else {
                    item.likes! -= 1
                }
            }
        } catch (let error) {
            showError(error)
        }
    }
}
