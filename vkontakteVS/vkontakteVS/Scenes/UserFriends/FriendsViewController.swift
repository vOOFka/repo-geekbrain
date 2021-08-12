//
//  FriendsViewController.swift
//  vkontakteVS
//
//  Created by Home on 21.07.2021.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak private var lettersControl: LettersControl!
    @IBOutlet weak private var tableView: UITableView!
    
    
    //MARK: - Var
    private let friendsLetters = Friend.lettersFriends()
    private let friendsCategory = FriendsCategory.allCategorys
    private let cellID = "FriendTableViewCell"
    private let sectionHeaderID = "FriendsSectionTableViewHeader"
    
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
        lettersControl.addTarget(self, action: #selector(letterWasChange(_:)), for: .valueChanged)
        
     }
    
    @objc private func letterWasChange(_ control: LettersControl) {
        let letter = control.selectedLetter
        let indexPath = IndexPath(item: 0, section: letter.0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension FriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsCategory.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderID) as? FriendsSectionTableViewHeader else {
            fatalError("Message: Error in dequeue FriendsSectionTableViewHeader")
        }
        header.tintColor = UIColor.systemTeal
        header.letterLabel.text = friendsCategory[section].categoryFriendName
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsCategory[section].friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FriendTableViewCell else {
            fatalError("Message: Error in dequeue FriendTableViewCell")
        }
        let category = friendsCategory[indexPath.section]
        let friendImage = category.friends[indexPath.item].image
        let friendName = category.friends[indexPath.item].name
        let tapRecognazer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        
        cell.friendImage.image = friendImage
        cell.friendName.text = friendName
        cell.friendImage.isUserInteractionEnabled = true
        cell.friendImage.addGestureRecognizer(tapRecognazer)
       
        return cell
    }
}

extension UIViewController {
    @objc func tapOnAvatar(tap: UITapGestureRecognizer){
        let tapImageView = tap.view as! UIImageView
        tapImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 10,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        tapImageView.transform = CGAffineTransform.identity
                       },
                       completion: nil)
    }
}
