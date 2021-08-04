//
//  FriendsTableViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak private var friendsTableView: UITableView!
    //@IBOutlet weak private var lettersControl: LettersControl!
    
    //MARK: - Var
    private let friendsLetters = Friend.lettersFriends()
    private let friendsCategory = FriendsCategory.allCategorys
    private let cellID = "FriendTableViewCell"
    private let sectionHeaderID = "FriendsSectionTableViewHeader"
    
    let lettersControl = LettersControl()
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhotoSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let friendClick = friendsCategory[indexPath.section].friends[indexPath.row] //friendsArray[indexPath.row]
            let currentFriendPhotosVC = segue.destination as! FriendPhotosCollectionViewController
            currentFriendPhotosVC.currentFriend = friendClick            
        }
    }
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register Header of cell
        tableView.register(UINib(nibName: sectionHeaderID, bundle: nil), forHeaderFooterViewReuseIdentifier: sectionHeaderID)
        //watch press LettersControl
        //lettersControl.addTarget(self, action: #selector(letterWasChange(_:)), for: .valueChanged)
        

        lettersControl.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 100)
        tableView.addSubview(lettersControl)
        
//        lettersControl.topAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.topAnchor).isActive = true
//        lettersControl.leadingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        lettersControl.trailingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        lettersControl.heightAnchor.constraint(equalToConstant: 200).isActive = true
     }
    
    @objc private func letterWasChange(_ control: LettersControl) {
        let letter = control.selectedLetter
        let indexPath = IndexPath(item: 0, section: letter.0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if(offset > 50){
        lettersControl.frame = CGRect(x: 0, y: offset - 50, width: self.view.bounds.size.width, height: 100)
        } else {
            self.lettersControl.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 100)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsCategory.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderID) as? FriendsSectionTableViewHeader else {
            fatalError("Message: Error in dequeue FriendsSectionTableViewHeader")
        }
        header.tintColor = UIColor.systemTeal
        header.letterLabel.text = friendsCategory[section].categoryFriendName
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsCategory[section].friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FriendTableViewCell else {
            fatalError("Message: Error in dequeue FriendTableViewCell")
        }
        let category = friendsCategory[indexPath.section]
        let friendImage = category.friends[indexPath.item].image
        let friendName = category.friends[indexPath.item].name
        
        cell.friendImage.image = friendImage
        cell.friendName.text = friendName
       
        return cell
    }
}
