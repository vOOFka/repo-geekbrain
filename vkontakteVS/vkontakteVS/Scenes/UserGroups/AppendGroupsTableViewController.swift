//
//  AppendGroupsTableViewController.swift
//  vkontakteVS
//
//  Created by Admin on 26.07.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class AppendGroupsTableViewController: UITableViewController {
    //MARK: - Outlets
    @IBOutlet private var appendGroupsTableView: UITableView!
    //MARK: - Properties
    private let networkService = NetworkServiceImplimentation()
    private let realmService: RealmService = RealmServiceImplimentation()
    private var foundAppendGroups = [RealmGroup()]
    private var searching = false
    private let searchView = GroupSearchBar()
    private let ref = Database.database().reference(withPath: "users")

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
        appendGroupsTableView.separatorStyle = .none
    }
    //MARK: - Functions
    fileprivate func foundGroupsFromVKAPI(searchText: String) {
        networkService.searchGroups(search: searchText, completion: { [weak self] groupsItems in
            guard let self = self,
                  let foundAppendGroups = groupsItems?.items else { return }
            //Преобразование в Realm модель
            self.foundAppendGroups = foundAppendGroups.map({ RealmGroup($0) })
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGroup = foundAppendGroups[indexPath.row]
        pushToRealm(selectGroup: selectGroup)
        //Загрузка данных в Firebase
        let selectGroupFirebase = GroupFirebase(id: selectGroup.id, name: selectGroup.name)
        let databaseRef = ref.child(String(UserSession.shared.userId)).child("groups").child(String(selectGroupFirebase.id))
        
        databaseRef.setValue(selectGroupFirebase.toAnyObject())        
    }
}

//MARK: - Functions
extension AppendGroupsTableViewController {
    //Загрузка данных в БД Realm
    fileprivate func pushToRealm(selectGroup: RealmGroup) {
        //Загрузка
        do {
//            let existItems = try realmService.get(RealmGroup.self)
//            let appendExistGroup = existItems.first(where: { $0.id == selectGroup.id })
//            if appendExistGroup != nil {
//                print("Такая группа уже есть")
//            }
            _ = try realmService.update(selectGroup)
        } catch (let error) {
            showError(error)
        }
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
