//
//  AveliableGroupsTableViewController.swift
//  vkontakteVS
//
//  Created by Admin on 26.07.2021.
//

import UIKit

class AveliableGroupsTableViewController: UITableViewController {

    //MARK: - Outlets
    @IBOutlet private var aveliableGroupsTableView: UITableView!
    
    //MARK: - Var
    let aveliableGroups = Group.aveliableGroups
    private let cellID = "AveliableGroupTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aveliableGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? GroupTableViewCell else {
            fatalError("Message: Error in dequeue GroupTableViewCell")
        }
        cell.groupImage.image = aveliableGroups[indexPath.row].image
        cell.groupName.text = aveliableGroups[indexPath.row].name
        
        return cell
    }

}
