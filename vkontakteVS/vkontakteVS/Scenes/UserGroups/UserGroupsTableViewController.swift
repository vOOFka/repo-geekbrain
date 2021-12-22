//
//  UserGroupsTableViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit
import RealmSwift
import PromiseKit

class UserGroupsTableViewController: UITableViewController {
   
    //MARK: - Outlets
    @IBOutlet private weak var groupsTableView: UITableView! {
        didSet {
            heightHeader = groupsTableView.frame.height * 0.2
        }
    }
    @IBOutlet private weak var groupsHeaderView: UIView!
    @IBOutlet private weak var bottom: NSLayoutConstraint!
    //MARK: - Properties
    private let networkService = NetworkServiceProxy(networkService: NetworkServiceImplimentation()) //NetworkServiceImplimentation()
    private let realmService: RealmService = RealmServiceImplimentation()
    private var userGroups: [Group] = []
    //var filteredUserGroups = [RealmGroup()]
    //var filteredUserGroups = [Group]()
    private var heightHeader: CGFloat = 0.0
    private let searchInNavigationBar = UISearchController(searchResultsController: nil)
    private var notificationToken: NotificationToken?
    private var sectionsForUpdate = [0]
    private let viewModelFactory = GroupsViewModelFactory()
    private var viewModels: [GroupsViewModel] = []

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = nil
        tableView.addSubview(groupsHeaderView)
        groupsHeaderView.clipsToBounds = true
        
        groupsTableView.separatorStyle = .none
        groupsTableView.allowsSelection = false
        
        tableView.contentInset = UIEdgeInsets(top: heightHeader, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -heightHeader)
        calculateHeightHeader()
        
        //Show groups from VK API
        promiseUpdateGroupsFromVKAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notificationToken?.invalidate()
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
//        guard !userGroups.contains(where: { group -> Bool in
//            group.name == newUserGroupe.name
//        }) else { return }
//    userGroups.append(newUserGroupe)
//        userGroups = filteredUserGroups
//        groupsTableView.reloadData()
    }
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupTableViewCell.self, for: indexPath)
        cell.configuration(currentGroup: viewModels[indexPath.row])
        return cell
    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        switch editingStyle {
//        case .delete:
//            sectionsForUpdate.append(indexPath.section)
//            let currentItem = userGroups[indexPath.row]
//            do {
//                guard let itemFromDB = try realmService.get(RealmGroup.self, primaryKey: currentItem.id) else { return }
//                try realmService.delete(itemFromDB)
//            } catch (let error) {
//                showError(error)
//            }
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        default:
//            return
//        }
//    }
}

//MARK: - Functions
extension UserGroupsTableViewController {
    //Загрузка данных из VK
    fileprivate func promiseUpdateGroupsFromVKAPI() {
        networkService.getGroups()
            .then(on: DispatchQueue.global(qos: .default), flags: nil, networkService.getParsingGroups(_:))
            .done { [weak self] groups in
                guard let self = self else { throw InternalErrors.ErrorSaveToRealmDB}
                _ = self.promisePushToRealm(groupsItems: groups)
                self.userGroups = groups.items
                self.viewModels = self.viewModelFactory.cunstructViewModels(from: groups.items)
                self.groupsTableView.reloadData()
            }
            .catch { error in
                print(error.localizedDescription)
            }
    }
    //Загрузка данных в БД Realm --- Promise
    fileprivate func promisePushToRealm(groupsItems: Groups) -> Promise<Bool> {
        return Promise<Bool> { isPush in
            //Преобразование в Realm модель
            let groupsItemsRealm = groupsItems.items.map({ RealmGroup($0) })
            //Загрузка
            do {
                let existItems = try realmService.get(RealmGroup.self)
                for item in groupsItemsRealm {
                    guard let existImg = existItems.first(where: { $0.id == item.id })?.imageAvatar else { break }
                    item.imageAvatar = existImg
                }
                _ = try realmService.update(groupsItemsRealm)
                isPush.fulfill(true)
            } catch (let error) {
                showError(error)
                isPush.reject(InternalErrors.ErrorSaveToRealmDB)
            }
        }
    }
}

extension UserGroupsTableViewController {
    //for Paralax Effect
    fileprivate func calculateHeightHeader() {
        var headerRect = CGRect(x: 0, y: -heightHeader, width: tableView.bounds.width, height: heightHeader)
        let bottom = groupsHeaderView.constraints.filter{ $0.identifier == "bottom"}.first
        let offsetY = tableView.contentOffset.y
        if tableView.contentOffset.y < -heightHeader {
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
            navigationItem.searchController = searchInNavigationBar
            searchInNavigationBar.delegate = self
            searchInNavigationBar.searchBar.delegate = self
            searchInNavigationBar.searchBar.sizeToFit()
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
