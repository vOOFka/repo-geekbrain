//
//  FriendsTableViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet var friendsTableView: UITableView!
  
    //MARK: - Var
    let friendsNameArray = Friend.getFriends()
    
    private let cellID = "FriendTableViewCell"
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhotoSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let friendClick = friendsNameArray[indexPath.row]
            let currentFriendPhotosVC = segue.destination as! FriendPhotosCollectionViewController
            currentFriendPhotosVC.currentFriend = friendClick            
        }
    }
    
    //MARK: - Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FriendTableViewCell else {
            fatalError("Все плохо!")
        }
        cell.friendImage.image = friendsNameArray[indexPath.row].image
        cell.friendName.text = friendsNameArray[indexPath.row].name
        
        return cell
        
    }

}
