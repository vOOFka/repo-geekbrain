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
    private let networkService = NetworkServiceImplimentation()
    private let realmService: RealmService = RealmServiceImplimentation()
    private var photosList: Results<RealmPhoto>!
    private let showFriendPhotoFullScreenVC = "FriendPhotoFullScreen"
    private var selectedImageId: Int = 0
    //Choice size download photo
    private let size = sizeTypeRealmEnum.mid
    private var notificationToken: NotificationToken?
    //MARK: Public properties
    public var currentFriend: Int = 0
   
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showFriendPhotoFullScreenVC {
            guard let fullScreenVC = segue.destination as? FriendPhotoFullScreen else {
                fatalError("Message: prepare for FriendPhotoFullScreen")
            }
            if selectedImageId != 0 {
                fullScreenVC.configuration(selectPhotoId: selectedImageId, anotherPhoto: photosList)
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
        notificationToken?.invalidate()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosList?.count ?? 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PhotosCollectionViewCell.self, for: indexPath)
        if !photosList.isEmpty {
            let photo = photosList[indexPath.row]
            cell.configuration(currentPhoto: photo, delegate: self)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageId = photosList[indexPath.row].id
        performSegue(withIdentifier: showFriendPhotoFullScreenVC, sender: nil)
    }
}
//MARK: - Functions
extension FriendPhotosCollectionViewController {
    fileprivate func updatePhotosFromVKAPI() {
        networkService.getPhotosAll(friendId: currentFriend, completion: { [weak self] photosItems in
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
            let existItems = try realmService.get(RealmPhoto.self)
            for item in photosItemsRealm {
                guard let existImg = existItems.first(where: { ($0.id == item.id) && ($0.ownerId == item.ownerId) })?.sizes.first(where: { $0.type == size })?.image else { continue }
                item.sizes.first(where: { $0.type == size })?.image = existImg
            }
            //let saveToDB = try realmService.save(photosItemsRealm)
            let saveToDB = try realmService.update(photosItemsRealm)
            print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
        } catch (let error) {
            showError(error)
        }
    }
    //Получение данных из БД
    fileprivate func pullFromRealm() {
        do {
            let friendPredicate = NSPredicate(format: "ownerId = %d", currentFriend)
            photosList = try realmService.get(RealmPhoto.self).filter(friendPredicate)
        } catch (let error) {
            showError(error)
        }
        collectionView.reloadData()
        //Наблюдение за изменениями
        watchingForChanges()
    }
    //Наблюдение за изменениями
    fileprivate func watchingForChanges() {
        notificationToken = photosList?.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .error(let error):
                self.showError(error)
            case .initial: break
            case .update:
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.collectionView.reloadData()
                 //   let updateKeys: [IndexPath] = self.selectedHearts.map{ $0.key }
                //    self.collectionView.reloadItems(at: updateKeys )
                }
            }
        })
    }
}

extension FriendPhotosCollectionViewController: LikesControlDelegate {
    func likeWasTap(at controlId: Int) {
        //print("Like! \(controlId)")
        do {
            guard let item = try realmService.get(RealmPhoto.self, primaryKey: controlId) else { return }
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
