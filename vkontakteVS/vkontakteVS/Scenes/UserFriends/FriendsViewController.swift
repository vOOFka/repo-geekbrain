//
//  FriendsViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class FriendsViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak private var lettersControl: LettersControl!
    @IBOutlet weak private var tableView: UITableView!
    //MARK: - Actions
    @IBAction func getDataFromWeb(_ sender: Any) {
        //Get friends from VK API
        updateFriendsFromVKAPI()
    }
    //MARK: - Properties
    let networkService = NetworkServiceImplimentation()
    let realmService: RealmService = RealmServiceImplimentation()
    var friendsList: Results<RealmFriend>!
    var sectionNames = [String]()
    var notificationToken: NotificationToken?
    var sectionsForUpdate = [0]
    let ref = Database.database().reference(withPath: "users")
    
    private let operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "com.AsyncOperation.FriendsViewController"
        operationQueue.qualityOfService = .utility
        return operationQueue
    }()
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhotoSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let category = friendsList.filter("category == %@", sectionNames[indexPath.section])
            let friendClick = category[indexPath.row].id
            let currentFriendPhotosVC = segue.destination as! FriendPhotosCollectionViewController
            currentFriendPhotosVC.currentFriend = friendClick
        }
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //register Header of cell
        tableView.register(FriendsSectionTableViewHeader.self)
        //watch press LettersControl
        lettersControl.addTarget(self, action: #selector(letterWasChange(_:)), for: .valueChanged)
        //for custom animation transition
        self.navigationController?.delegate = self
        //Get friends from VK API
        updateFriendsFromVKAPI()
        //Наблюдение за изменениями
        watchingForChanges()
        //Передаем данные в Firebase
        pullDataToFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.setNavigationBarHidden(true, animated: animated)
        //Pull data friends from RealmDB
        //pullFromRealm()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: animated)
        notificationToken?.invalidate()
    }
}

extension FriendsViewController: UITableViewDataSource {    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(FriendsSectionTableViewHeader.self, viewForHeaderInSection: section)
        header.contentView.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        header.contentView.alpha = 0.7
        header.letterLabel.text = sectionNames[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.filter("category == %@", sectionNames[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(FriendTableViewCell.self, for: indexPath)
        let category = friendsList.filter("category == %@", sectionNames[indexPath.section])
        let currentCellFriend = category[indexPath.row]
        cell.configuration(currentFriend: currentCellFriend)
        return cell
    }
}

//MARK: - Functions
extension FriendsViewController {
    //Загрузка данных в Firebase
    fileprivate func pullDataToFirebase() {
        let user = UserFirebase(userId: UserSession.shared.userId, userName: UserSession.shared.userName)
        let userRef = ref.child(String(user.userId))
        
        userRef.setValue(user.toAnyObject())
    }
    //Загрузка данных из VK
    fileprivate func updateFriendsFromVKAPI() {
        let request = networkService.getFriendsRequest()
        let getData = AFGetDataOperation(request: request)
        let parseData = DataParsingOperation<Friends>()
        let pushToRealm = PushFriendsToRealmOperation<Friends>()
        let pullFromRealm = PullFriendsFromRealmOperation(friends: self)
        let completionOperation = BlockOperation {
            self.tableView.reloadData()
        }

        parseData.addDependency(getData)
        pushToRealm.addDependency(parseData)
        pullFromRealm.addDependency(pushToRealm)
        completionOperation.addDependency(pullFromRealm)

        operationQueue.addOperation(getData)
        operationQueue.addOperation(parseData)
        operationQueue.addOperation(pushToRealm)
        OperationQueue.main.addOperation(pullFromRealm)
        OperationQueue.main.addOperation(completionOperation)
        
//        networkService.getFriends(completion: { [weak self] friendsItems in
//            guard let self = self else { return }
//            self.pushToRealm(friendsItems: friendsItems)
//            //Pull data friends from RealmDB
//            self.pullFromRealm()
//        })
    }
    //Загрузка данных в БД Realm
    fileprivate func pushToRealm(friendsItems: Friends?) {
        guard let friendsItems = friendsItems?.items else { return }
        //Преобразование в Realm модель
        let friendsItemsRealm = friendsItems.map({ RealmFriend($0) })
        //Загрузка
        do {
            let existItems = try realmService.get(RealmFriend.self)
            for item in friendsItemsRealm {
                guard let existImg = existItems.first(where: { $0.id == item.id })?.imageAvatar else { break }
                item.imageAvatar = existImg
            }
            //let saveToDB = try realmService.save(friendsItemsRealm)
            let saveToDB = try realmService.update(friendsItemsRealm)
            print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
        } catch (let error) {
            showError(error)
        }
    }
    //Получение данных из БД
    fileprivate func pullFromRealm() {
        do {
            friendsList = try realmService.get(RealmFriend.self)
            //Получение категорий
            let friendsCategory = friendsList.sorted(by: ["category", "fullName"])
            sectionNames = Set(friendsCategory.value(forKeyPath: "category") as! [String]).sorted()
        } catch (let error) {
            showError(error)
        }
        tableView.reloadData()
        //Update custom UIControl
        //        let friendsLetters = lettersFriends(array: friendsItems)
        //        lettersControl.setupControl(array: friendsLetters)
    }
    //    fileprivate func lettersFriends(array friends: [Friend]) -> [String] {
    //        let friendsNameArray = friends.map({ $0.firstName + $0.lastName })
    //        var array = friendsNameArray.map({ String($0.first!) })
    //        array = Array(Set(array))
    //        return array.sorted()
    //    }
    @objc private func letterWasChange(_ control: LettersControl) {
        let letter = control.selectedLetter
        let indexPath = IndexPath(item: 0, section: letter.0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    //Наблюдение за изменениями
    fileprivate func watchingForChanges() {
        notificationToken = friendsList?.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .error(let error):
                self.showError(error)
            case .initial: break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.tableView.updateTableView(deletions: deletions, insertions: insertions, modifications: modifications, sections: self.sectionsForUpdate)
                //Return to default
                self.sectionsForUpdate = [0]
            }
        })
    }
}

extension FriendsViewController: UINavigationControllerDelegate {
    //Animation NavigationController
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
