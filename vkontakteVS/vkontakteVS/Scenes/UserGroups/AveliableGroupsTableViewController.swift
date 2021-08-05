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
    private let searchInNavigationBar = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // MARK: - Actions
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        showHideSearchBar()
    }
}

extension AveliableGroupsTableViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func showHideSearchBar() {
        if navigationItem.searchController == nil {
            navigationItem.searchController = searchInNavigationBar
            searchInNavigationBar.delegate = self
            searchInNavigationBar.searchBar.delegate = self
            searchInNavigationBar.searchBar.sizeToFit()
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.searchController = nil
            filteredAveliableGroups.removeAll()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredAveliableGroups.removeAll()
        if searchText == "" {
            aveliableGroups = Group.aveliableGroups
        } else {
            aveliableGroups = aveliableGroups.filter( { ($0.name).uppercased().contains(searchText.uppercased()) } )
        }
        tableView.reloadData()
    }
}
