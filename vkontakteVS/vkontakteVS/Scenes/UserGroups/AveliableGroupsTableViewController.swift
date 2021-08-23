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
    var aveliableGroups = Group.aveliableGroups
    private var filteredAveliableGroups = [Group]()
    private let cellID = "AveliableGroupTableViewCell"
    private let searchView = GroupSearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self        
        aveliableGroupsTableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aveliableGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? GroupTableViewCell else {
            fatalError("Message: Error in dequeue GroupTableViewCell")
        }
        let tapRecognazer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        cell.groupImage.image = aveliableGroups[indexPath.row].image
        cell.groupName.text = aveliableGroups[indexPath.row].name
        cell.groupImage.isUserInteractionEnabled = true
        cell.groupImage.addGestureRecognizer(tapRecognazer)
        return cell
    }
}

extension AveliableGroupsTableViewController:  UISearchBarDelegate  {
    //Config searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filteredUserGroups.removeAll()
        if searchText == "" {
            aveliableGroups = Group.aveliableGroups
        } else {
            aveliableGroups = aveliableGroups.filter( { ($0.name).uppercased().contains(searchText.uppercased()) } )
        }
        tableView.reloadData()
    }
}
