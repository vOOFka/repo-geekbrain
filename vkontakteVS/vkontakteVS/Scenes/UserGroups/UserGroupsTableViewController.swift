//
//  UserGroupsTableViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class UserGroupsTableViewController: UITableViewController {
   
    //MARK: - Outlets
    @IBOutlet private weak var groupsTableView: UITableView! {
        didSet {
            heightHeader = groupsTableView.frame.height * 0.2
        }
    }
    @IBOutlet private weak var groupsHeaderView: UIView!
    @IBOutlet private weak var bottom: NSLayoutConstraint!
    
    //MARK: - Var
    private var userGroups = [Group]()
    private var filteredUserGroups = [Group]()
    private var heightHeader: CGFloat = 0.0
    private let searchInNavigationBar = UISearchController(searchResultsController: nil)
    private let networkService = NetworkService()
    
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
        updateGroupsFromVKAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateHeightHeader()
    }
    //MARK: - Functions
    fileprivate func updateGroupsFromVKAPI() {
        networkService.getGroups(completion: { [weak self] groupsItems in
            self?.userGroups = groupsItems?.items ?? [Group]()
            self?.filteredUserGroups = groupsItems?.items ?? [Group]()
            self?.groupsTableView.reloadData()
        })
    }
    // MARK: - Actions
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        showHideSearchBar()
    }
    //MARK: - Navigation
    @IBAction func goBackFromAppendGroups (with segue: UIStoryboardSegue) {
        guard let appendVC = segue.source as? AppendGroupsTableViewController,
              let indexPath = appendVC.tableView.indexPathForSelectedRow else { return }
        let newUserGroupe = appendVC.foundAppendGroups[indexPath.row]
        guard !filteredUserGroups.contains(where: { group -> Bool in
            group.name == newUserGroupe.name
        }) else { return }
        filteredUserGroups.append(newUserGroupe)
        userGroups = filteredUserGroups
        groupsTableView.reloadData()
    }
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUserGroups.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupTableViewCell.self, for: indexPath)
        let currentCellFGroup = filteredUserGroups[indexPath.row]
        cell.configuration(currentGroup: currentCellFGroup)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            filteredUserGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
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
            filteredUserGroups = userGroups.filter( { ($0.name).uppercased().contains(searchText.uppercased()) } )
        } else {
            filteredUserGroups = userGroups
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
