//
//  GroupTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class GroupTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var groupImage: UIImageView! {
        didSet {
            groupImage.layer.cornerRadius = 10.0
            groupImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var groupName: UILabel!

    //MARK: - Functions
    func configuration(currentGroup: GroupsViewModel) {
        let tapRecognazer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        groupName.text = currentGroup.name
        groupImage.image = UIImage(data: currentGroup.imageAvatar!)
        groupImage.isUserInteractionEnabled = true
        groupImage.addGestureRecognizer(tapRecognazer)  
    }
}
