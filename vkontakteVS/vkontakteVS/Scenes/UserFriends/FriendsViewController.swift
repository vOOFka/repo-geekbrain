//
//  FriendsViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit
import RealmSwift

class FriendsViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak private var lettersControl: LettersControl!
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties
    private struct Properties {
        static let networkService = NetworkServiceImplimentation()
        static let realmService: RealmService = RealmServiceImplimentation()
        static var friendsList: Results<RealmFriend>!
        static var sectionNames = [String]()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhotoSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let friendClick = Properties.friendsList[indexPath.row].id
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
        //Pull data friends from RealmDB
        pullFromRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension FriendsViewController: UITableViewDataSource {    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Properties.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(FriendsSectionTableViewHeader.self, viewForHeaderInSection: section)
        header.contentView.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        header.contentView.alpha = 0.7
        header.letterLabel.text = Properties.sectionNames[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Properties.friendsList.filter("category == %@", Properties.sectionNames[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(FriendTableViewCell.self, for: indexPath)
        let category = Properties.friendsList.filter("category == %@", Properties.sectionNames[indexPath.section])
        let currentCellFriend = category[indexPath.row]
        cell.configuration(currentFriend: currentCellFriend)
        return cell
    }
}

//MARK: - Functions
extension FriendsViewController {
        fileprivate func updateFriendsFromVKAPI() {
            Properties.networkService.getFriends(completion: { [weak self] friendsItems in
                guard let self = self else { return }
                self.pushToRealm(friendsItems: friendsItems)
            })
        }
    
        //Загрузка данных в БД Realm
        fileprivate func pushToRealm(friendsItems: Friends?) {
            guard let friendsItems = friendsItems?.items else { return }
            //Преобразование в Realm модель
            let friendsItemsRealm = friendsItems.map({ RealmFriend($0, image: nil) })
            //Загрузка
            do {
                //let saveToDB = try realmService.save(friendsItemsRealm)
                let saveToDB = try Properties.realmService.update(friendsItemsRealm)
                print(saveToDB.configuration.fileURL?.absoluteString ?? "No avaliable file DB")
            } catch (let error) {
                print(error)
            }
        }
    
        //Получение данных из БД
        fileprivate func pullFromRealm() {
            do {
                Properties.friendsList = try Properties.realmService.get(RealmFriend.self)
                //Получение категорий
                let friendsCategory = Properties.friendsList.sorted(by: ["category", "fullName"])
                Properties.sectionNames = Set(friendsCategory.value(forKeyPath: "category") as! [String]).sorted()
            } catch (let error) {
                print(error)
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
