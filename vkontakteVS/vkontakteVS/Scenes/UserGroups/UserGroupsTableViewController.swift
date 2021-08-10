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
            heightHeader = groupsTableView.frame.height * 0.3
        }
    }
    @IBOutlet private weak var groupsHeaderView: UIView!
    @IBOutlet private weak var bottom: NSLayoutConstraint!
    
    //MARK: - Var
    private var userGroups = Group.userGroups
    private let cellID = "GroupTableViewCell"
    private let searchView = GroupSearchBar()
    //private var filteredUserGroups = [Group]()
    private var heightHeader: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
        //searchView.frame = CGRect(x: 0, y: 70, width: tableView.bounds.width, height: 50)
        
        tableView.tableHeaderView = nil
        tableView.addSubview(groupsHeaderView)
        groupsHeaderView.clipsToBounds = true
        //groupsHeaderView.addSubview(searchView)
        
        groupsTableView.separatorStyle = .none
        groupsTableView.allowsSelection = false
        
        tableView.contentInset = UIEdgeInsets(top: heightHeader, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -heightHeader)
        calculateHeightHeader()

    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateHeightHeader()
    }
    
    //MARK: - Navigation
    @IBAction func goBackFromAveliableGroups (with segue: UIStoryboardSegue) {
        guard let aveliableVC = segue.source as? AveliableGroupsTableViewController,
              let indexPath = aveliableVC.tableView.indexPathForSelectedRow else { return }
        
        let newUserGroupe = aveliableVC.aveliableGroups[indexPath.row]
        
        guard !userGroups.contains(where: { group -> Bool in
            group.name == newUserGroupe.name
        }) else { return }
        
        userGroups.append(newUserGroupe)
        groupsTableView.reloadData()
    }
    
    //MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return searchView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? GroupTableViewCell else {
            fatalError(" Message: Error in dequeue GroupTableViewCell")
        }
        cell.groupImage.image = userGroups[indexPath.row].image
        cell.groupName.text = userGroups[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            userGroups.remove(at: indexPath.row)
            //tableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }
}

extension UserGroupsTableViewController:  UISearchBarDelegate  {
    //Config searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filteredUserGroups.removeAll()
        if searchText == "" {
            userGroups = Group.userGroups
        } else {
            userGroups = userGroups.filter( { ($0.name).uppercased().contains(searchText.uppercased()) } )
        }
        tableView.reloadData()
    }
}

extension UserGroupsTableViewController {
    //for Paralax Effect
    func calculateHeightHeader() {
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
