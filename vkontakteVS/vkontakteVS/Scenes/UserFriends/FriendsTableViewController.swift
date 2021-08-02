//
//  FriendsTableViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak private var friendsTableView: UITableView!
    
    //MARK: - Var
    private let friendsLetters = Friend.lettersFriends()
    private let friendsCategory = FriendsCategory.allCategorys
    private let cellID = "FriendTableViewCell"
    private let cellHeaderID = "FriendsTableViewHeader"
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhotoSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let friendClick = friendsCategory[indexPath.section].friends[indexPath.row] //friendsArray[indexPath.row]
            let currentFriendPhotosVC = segue.destination as! FriendPhotosCollectionViewController
            currentFriendPhotosVC.currentFriend = friendClick            
        }
    }
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellHeaderID, bundle: nil), forHeaderFooterViewReuseIdentifier: cellHeaderID)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsCategory.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: cellHeaderID) as! FriendsTableViewHeader
        header.tintColor = UIColor.systemTeal
        header.letterLabel.text = friendsCategory[section].categoryFriendName
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsCategory[section].friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FriendTableViewCell else {
            fatalError("Message: Error in dequeue FriendTableViewCell")
        }
        let category = friendsCategory[indexPath.section]
        let friendImage = category.friends[indexPath.item].image
        let friendName = category.friends[indexPath.item].name
        
        cell.friendImage.image = friendImage
        cell.friendName.text = friendName
       
        return cell
    }
}
