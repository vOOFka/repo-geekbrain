//
//  AppendGroupsTableViewController.swift
//  vkontakteVS
//
//  Created by Admin on 26.07.2021.
//

import UIKit

class AppendGroupsTableViewController: UITableViewController {
    //MARK: - Outlets
    @IBOutlet private var appendGroupsTableView: UITableView!
    //MARK: - Properties
//    private var appendGroups = [Group]()
    var foundAppendGroups = [Group]()
    private var searching = false
    private let searchView = GroupSearchBar()
    private let networkService = NetworkServiceImplimentation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
        appendGroupsTableView.separatorStyle = .none
    }
    //MARK: - Functions
    fileprivate func foundGroupsFromVKAPI(searchText: String) {
        networkService.searchGroups(search: searchText, completion: { [weak self] groupsItems in
            guard let self = self else { return }
            self.foundAppendGroups = groupsItems?.items ?? []
            self.appendGroupsTableView.reloadData()
        })
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return foundAppendGroups.count
        } else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupTableViewCell.self, for: indexPath)
        cell.configuration(currentGroup: foundAppendGroups[indexPath.row])
        return cell
    }
}

extension AppendGroupsTableViewController:  UISearchBarDelegate  {
    func searchGroups(_ searchText: String) {
        if searchText != "" {
            searching = true
            foundGroupsFromVKAPI(searchText: searchText)
        } else {
            searching = false
            foundAppendGroups.removeAll()
            appendGroupsTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.searchTextField.text ?? ""
        searchGroups(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchGroups("")
    }
}
