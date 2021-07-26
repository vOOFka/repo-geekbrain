//
//  UserGroupsTableViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class UserGroupsTableViewController: UITableViewController {
   
    //MARK: - Outlets
    @IBOutlet var groupsTableView: UITableView!
    
    //MARK: - Var
    var userGroupsNames = ["Автолюбители","Гринпис"]
    lazy var userGroups = Group.getGroups(userGroupsNames)
    private let cellID = "GroupTableViewCell"
    
    //MARK: - Navigation
    @IBAction func goBackFromAveliableGroups (with segue: UIStoryboardSegue) {
        guard let aveliableVC = segue.source as? AveliableGroupsTableViewController,
              let indexPath = aveliableVC.tableView.indexPathForSelectedRow else { return }
        
        let newUserGroupe = aveliableVC.aveliableGroups[indexPath.row]
        
        guard !userGroups.contains(where: { group -> Bool in
            group.name == newUserGroupe.name
        }) else { return }
        
        //userGroupsNames.append(newUserGroupe.name)
        userGroups.append(newUserGroupe)
        groupsTableView.reloadData()
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? GroupTableViewCell else {
            fatalError("Все плохо!")
        }
        cell.groupImage.image = userGroups[indexPath.row].image
        cell.groupName.text = userGroups[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            userGroups.remove(at: indexPath.row)
            tableView.reloadData()
        default:
            return
        }
    }
    
}
