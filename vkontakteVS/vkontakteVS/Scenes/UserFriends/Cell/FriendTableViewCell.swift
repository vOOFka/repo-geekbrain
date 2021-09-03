//
//  FriendTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
  
    //MARK: - Outlets
    @IBOutlet weak var friendImage: UIImageView! {
        didSet {
            friendImage.layer.cornerRadius = friendImage.frame.size.height / 2
            friendImage.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var cityName: UILabel!
}
