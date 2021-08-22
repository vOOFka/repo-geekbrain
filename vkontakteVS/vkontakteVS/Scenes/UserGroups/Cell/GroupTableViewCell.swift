//
//  GroupTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var groupImage: UIImageView! {
        didSet {
            groupImage.layer.cornerRadius = 10.0
            groupImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var groupName: UILabel!

}
