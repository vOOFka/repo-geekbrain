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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGroup = Properties.foundAppendGroups[indexPath.row]
        //print("push to Realm: \(selectGroup)")
        pushToRealm(selectGroup: selectGroup)
    }
}

//MARK: - Functions
extension AppendGroupsTableViewController {
    //Загрузка данных в БД Realm
    fileprivate func pushToRealm(selectGroup: RealmGroup) {
        //Загрузка
        do {
//            let existItems = try Properties.realmService.get(RealmGroup.self)
//            let appendExistGroup = existItems.first(where: { $0.id == selectGroup.id })
//            if appendExistGroup != nil {
//                print("Такая группа уже есть")
//            }
            _ = try Properties.realmService.update(selectGroup)
        } catch (let error) {
            showError(error)
        }
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
