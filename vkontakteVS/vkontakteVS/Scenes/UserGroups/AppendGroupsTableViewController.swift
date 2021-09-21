//
//  AppendGroupsTableViewController.swift
//  vkontakteVS
//
//  Created by Admin on 26.07.2021.
//

import UIKit
import RealmSwift

class AppendGroupsTableViewController: UITableViewController {
    //MARK: - Outlets
    @IBOutlet private var appendGroupsTableView: UITableView!
    //MARK: - Properties
    private struct Properties {
        static let networkService = NetworkServiceImplimentation()
        static let realmService: RealmService = RealmServiceImplimentation()
        static var foundAppendGroups = [RealmGroup()]
        static var searching = false
        static let searchView = GroupSearchBar()
    }

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Properties.searchView.delegate = self
        appendGroupsTableView.separatorStyle = .none
    }
    //MARK: - Functions
    fileprivate func foundGroupsFromVKAPI(searchText: String) {
        Properties.networkService.searchGroups(search: searchText, completion: { [weak self] groupsItems in
            guard let self = self,
                  let foundAppendGroups = groupsItems?.items else { return }
            //Преобразование в Realm модель
            Properties.foundAppendGroups = foundAppendGroups.map({ RealmGroup($0) })
            self.appendGroupsTableView.reloadData()
        })
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Properties.searching {
            return Properties.foundAppendGroups.count
        } else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupTableViewCell.self, for: indexPath)
        cell.configuration(currentGroup: Properties.foundAppendGroups[indexPath.row])
        return cell
    }
}

extension AppendGroupsTableViewController:  UISearchBarDelegate  {
    func searchGroups(_ searchText: String) {
        if searchText != "" {
            Properties.searching = true
            foundGroupsFromVKAPI(searchText: searchText)
        } else {
            Properties.searching = false
            Properties.foundAppendGroups.removeAll()
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
