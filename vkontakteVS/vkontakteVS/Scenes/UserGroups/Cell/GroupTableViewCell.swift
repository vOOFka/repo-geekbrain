//
//  GroupTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit
import Kingfisher

class GroupTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var groupImage: UIImageView! {
        didSet {
            groupImage.layer.cornerRadius = 10.0
            groupImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var groupName: UILabel!
    //MARK: - Prefirence
    private let networkService = NetworkServiceInplimentation()
    //MARK: - Functions
    func configuration(currentGroup: Group) {
        let tapRecognazer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        groupName.text = currentGroup.name
        let url = currentGroup.urlPhoto
        if  url != nil {
            groupImage.kf.setImage(with: URL(string: url!))
        }
//        DispatchQueue.main.async {
//            self.networkService.getImageFromWeb(imageURL: currentGroup.urlPhoto , completion: { [weak self] imageAvatar in self?.groupImage.image = imageAvatar })
//        }
        groupImage.isUserInteractionEnabled = true
        groupImage.addGestureRecognizer(tapRecognazer)
    }
}
