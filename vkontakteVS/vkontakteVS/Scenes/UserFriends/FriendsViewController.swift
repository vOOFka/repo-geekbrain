//
//  FriendsViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit
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
    private let networkService = NetworkServiceAdapter()
    var friendsList: [FriendViewModel] = []
    private var friendsCategory = [FriendsCategory]()
    var sectionNames = [String]()
    private var sectionsForUpdate = [0]
    private let ref = Database.database().reference(withPath: "users")
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhotoSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let friendClick = friendsCategory[indexPath.section].friends[indexPath.row]
            let currentFriendPhotosVC = segue.destination as! FriendPhotosCollectionViewController
            currentFriendPhotosVC.currentFriend = friendClick.id
        }
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //register Header of cell
        tableView.register(FriendsSectionTableViewHeader.self)
        //watch press LettersControl
        //lettersControl.addTarget(self, action: #selector(letterWasChange(_:)), for: .valueChanged)
        //for custom animation transition
        self.navigationController?.delegate = self
        //Get friends from VK API
        updateFriendsFromVKAPI()
        //Передаем данные в Firebase
        pullDataToFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension FriendsViewController: UITableViewDataSource {    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsCategory.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(FriendsSectionTableViewHeader.self, viewForHeaderInSection: section)
        header.contentView.backgroundColor = UIColor.myLightBlue
        header.contentView.alpha = 0.7
        header.letterLabel.text = friendsCategory[section].category
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsCategory[section].friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(FriendTableViewCell.self, for: indexPath)
        let category = friendsCategory[indexPath.section]
        let currentCellFriend = category.friends[indexPath.item]
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
        networkService.getFriends(completion: { [weak self] friends in
            self?.friendsList.removeAll()
            self?.friendsCategory.removeAll()
            
            self?.friendsList = friends
            self?.getCategory(friends)
            self?.tableView.reloadData()
        })
    }
    
    fileprivate func getCategory(_ friendsItems: [FriendViewModel]) {
        //Получение категорий через словарь
        let friendsCategoryDictionary = Dictionary(grouping: friendsItems) { $0.category }
        for (_, value) in friendsCategoryDictionary.enumerated() {
            let category = FriendsCategory(category: value.key, array: value.value)
            friendsCategory.append(category)
        }
        friendsCategory.sort(by: { $0.category < $1.category })
    }

    //    fileprivate func lettersFriends(array friends: [Friend]) -> [String] {
    //        let friendsNameArray = friends.map({ $0.firstName + $0.lastName })
    //        var array = friendsNameArray.map({ String($0.first!) })
    //        array = Array(Set(array))
    //        return array.sorted()
    //    }
    //    @objc private func letterWasChange(_ control: LettersControl) {
    //        let letter = control.selectedLetter
    //        let indexPath = IndexPath(item: 0, section: letter.0)
    //        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    //    }
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
