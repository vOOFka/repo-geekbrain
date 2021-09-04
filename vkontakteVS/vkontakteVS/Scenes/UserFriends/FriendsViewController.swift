//
//  FriendsViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak private var lettersControl: LettersControl!
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Var
    private var friendsLetters = [String]()
    private var friendsCategory = [FriendsCategory]()
    private var friendsCategoryDictionary = [String : [Friend]]()
    private var friendsItems = [Friend]()
    private let cellID = "FriendTableViewCell"
    private let sectionHeaderID = "FriendsSectionTableViewHeader"
    private let networkService = NetworkService()
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhotoSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let friendClick = friendsCategory[indexPath.section].friends[indexPath.row]
            let currentFriendPhotosVC = segue.destination as! FriendPhotosCollectionViewController
            currentFriendPhotosVC.currentFriend = friendClick
        }
    }
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //register Header of cell
        tableView.register(UINib(nibName: sectionHeaderID, bundle: nil), forHeaderFooterViewReuseIdentifier: sectionHeaderID)
        //watch press LettersControl
        lettersControl.addTarget(self, action: #selector(letterWasChange(_:)), for: .valueChanged)
        //for custom animation transition
        self.navigationController?.delegate = self
        //Show friends from VK API
        updateFriendsFromVKAPI()
     }
    
    @objc private func letterWasChange(_ control: LettersControl) {
        let letter = control.selectedLetter
        let indexPath = IndexPath(item: 0, section: letter.0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func updateFriendsFromVKAPI() {
        networkService.getFriends(completion: { [weak self] friendsItems in
            self?.friendsItems = friendsItems?.items ?? [Friend]()
            //Получение категорий через метод
            //self?.friendsCategory = (friendsItems?.getFriendsCategory(array: self!.friendsItems))!
            //Получение категорий через словарь, как лучше?
            self?.friendsCategoryDictionary = Dictionary(grouping: self!.friendsItems) { $0.category }
            for (_, value) in self!.friendsCategoryDictionary.enumerated() {
                let category = FriendsCategory(category: value.key, array: value.value)
                self?.friendsCategory.append(category)
            }
            self?.friendsCategory.sort(by: { $0.category < $1.category })
            
            self?.friendsLetters = (friendsItems?.lettersFriends(array: self!.friendsItems))!
            self?.tableView.reloadData()
            //Update custom UIControl
            self!.lettersControl.setupControl(array: self?.friendsLetters ?? [String]())
        })
    }
}

extension FriendsViewController: UITableViewDataSource {    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsCategory.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderID) as? FriendsSectionTableViewHeader else {
            fatalError("Message: Error in dequeue FriendsSectionTableViewHeader")
        }
        header.contentView.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
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

extension FriendsViewController: UINavigationControllerDelegate {
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
