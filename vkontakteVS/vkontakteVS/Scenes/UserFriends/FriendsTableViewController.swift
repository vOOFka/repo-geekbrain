//
//  FriendsTableViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet private var friendsTableView: UITableView!
  
    //MARK: - Var
    private let friendsArray = Friend.allFriends
    private let friendsLetters = Friend.lettersFriends()
    private let friendsCategory = FriendsCategory.allCategorys
    private let cellID = "FriendTableViewCell"
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhotoSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let friendClick = friendsArray[indexPath.row]
            let currentFriendPhotosVC = segue.destination as! FriendPhotosCollectionViewController
            currentFriendPhotosVC.currentFriend = friendClick            
        }
    }
    
    //MARK: - Functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsCategory.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsCategory.first!.friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FriendTableViewCell else {
            fatalError("Message: Error in dequeue FriendTableViewCell")
        }
        
        cell.friendImage.image = friendsArray[indexPath.row].image
        cell.friendName.text = friendsArray[indexPath.row].name
        
        return cell
        
    }

}
