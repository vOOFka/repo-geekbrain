//
//  UserGroupsTableViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit
import RealmSwift

class UserGroupsTableViewController: UITableViewController {
   
    //MARK: - Outlets
    @IBOutlet private weak var groupsTableView: UITableView! {
        didSet {
            Properties.heightHeader = groupsTableView.frame.height * 0.2
        }
    }
    @IBOutlet private weak var groupsHeaderView: UIView!
    @IBOutlet private weak var bottom: NSLayoutConstraint!
    //MARK: - Properties
    private struct Properties {
        static let networkService = NetworkServiceImplimentation()
        static let realmService: RealmService = RealmServiceImplimentation()
        static var userGroups: Results<RealmGroup>!
        //static var filteredUserGroups = [RealmGroup()]
        //   static var userGroups = [Group]()
        //   static var filteredUserGroups = [Group]()
        static var heightHeader: CGFloat = 0.0
        static let searchInNavigationBar = UISearchController(searchResultsController: nil)
        static var notificationToken: NotificationToken?
        static var sectionsForUpdate = [0]
    }
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        watchingForChanges()
        tableView.tableHeaderView = nil
        tableView.addSubview(groupsHeaderView)
        groupsHeaderView.clipsToBounds = true
        
        groupsTableView.separatorStyle = .none
        groupsTableView.allowsSelection = false
        
        tableView.contentInset = UIEdgeInsets(top: Properties.heightHeader, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -Properties.heightHeader)
        calculateHeightHeader()
        
        //Show groups from VK API
        updateGroupsFromVKAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Pull data groups from RealmDB
        pullFromRealm()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Properties.notificationToken?.invalidate()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateHeightHeader()
    }
    // MARK: - Actions
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        showHideSearchBar()
    }
    //MARK: - Navigation
    @IBAction func goBackFromAppendGroups (with segue: UIStoryboardSegue) {
//        guard let appendVC = segue.source as? AppendGroupsTableViewController,
//              let indexPath = appendVC.tableView.indexPathForSelectedRow else { return }
//        let newUserGroupe = appendVC.foundAppendGroups[indexPath.row]
//        guard !Properties.userGroups.contains(where: { group -> Bool in
//            group.name == newUserGroupe.name
//        }) else { return }
//    Properties.userGroups.append(newUserGroupe)
//        userGroups = filteredUserGroups
//        groupsTableView.reloadData()
    }
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Properties.userGroups?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupTableViewCell.self, for: indexPath)
        let currentCellGroup = Properties.userGroups[indexPath.row]
        cell.configuration(currentGroup: currentCellGroup)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            //Properties.userGroups.remove(at: indexPath.row)
            Properties.sectionsForUpdate.append(indexPath.section)
            let currentItem = Properties.userGroups[indexPath.row]
            do {
                guard let itemFromDB = try Properties.realmService.get(RealmGroup.self, primaryKey: currentItem.id) else { return }
                try Properties.realmService.delete(itemFromDB)
            } catch (let error) {
                showError(error)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }
}

//MARK: - Functions
extension UserGroupsTableViewController {
    //Загрузка данных из VK
    fileprivate func updateGroupsFromVKAPI() {
        Properties.networkService.getGroups(completion: { [weak self] groupsItems in
            guard let self = self else { return }
            self.pushToRealm(groupsItems: groupsItems)
            //Pull data groups from RealmDB
            self.pullFromRealm()
        })
    }
    
    //Загрузка данных в БД Realm
    fileprivate func pushToRealm(groupsItems: Groups?) {
        guard let groupsItems = groupsItems?.items else { return }
        //Преобразование в Realm модель
        let groupsItemsRealm = groupsItems.map({ RealmGroup($0) })
        //Загрузка
        do {
            let existItems = try Properties.realmService.get(RealmGroup.self)
            for item in groupsItemsRealm {
                guard let existImg = existItems.first(where: { $0.id == item.id })?.imageAvatar else { break }
                item.imageAvatar = existImg
            }
            _ = try Properties.realmService.update(groupsItemsRealm)
        } catch (let error) {
            showError(error)
        }
    }
    
    //Получение данных из БД
    fileprivate func pullFromRealm() {
        do {
            Properties.userGroups = try Properties.realmService.get(RealmGroup.self)
        } catch (let error) {
            showError(error)
        }
        groupsTableView.reloadData()
    }
    //Наблюдение за изменениями
    fileprivate func watchingForChanges() {
        Properties.notificationToken = Properties.userGroups?.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .error(let error):
                self.showError(error)
            case .initial: break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.groupsTableView.updateTableView(deletions: deletions, insertions: insertions, modifications: modifications, sections: Properties.sectionsForUpdate)
                //Return to default
                Properties.sectionsForUpdate = [0]
            }
        })
    }
}

extension UserGroupsTableViewController {
    //for Paralax Effect
    fileprivate func calculateHeightHeader() {
        var headerRect = CGRect(x: 0, y: -Properties.heightHeader, width: tableView.bounds.width, height: Properties.heightHeader)
        let bottom = groupsHeaderView.constraints.filter{ $0.identifier == "bottom"}.first
        let offsetY = tableView.contentOffset.y
        if tableView.contentOffset.y < -Properties.heightHeader {
            headerRect.origin.y = offsetY
            headerRect.size.height = -offsetY
        }
        bottom?.constant = offsetY <= 0 ? offsetY / 2 : 0
        groupsHeaderView.frame = headerRect
    }
}

extension UserGroupsTableViewController: UISearchControllerDelegate, UISearchBarDelegate { 
    fileprivate func showHideSearchBar() {
        if navigationItem.searchController == nil {
            navigationItem.searchController = Properties.searchInNavigationBar
            Properties.searchInNavigationBar.delegate = self
            Properties.searchInNavigationBar.searchBar.delegate = self
            Properties.searchInNavigationBar.searchBar.sizeToFit()
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.searchController = nil
        }
    }
    
    internal func searchGroups(_ searchText: String) {
        if searchText != "" {
         //   filteredUserGroups = userGroups.filter( { ($0.name).uppercased().contains(searchText.uppercased()) } )
        } else {
        //    filteredUserGroups = userGroups
        }
        groupsTableView.reloadData()
    }
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchGroups(searchText)
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.searchTextField.text ?? ""
        searchGroups(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchGroups("")
    }
}
