//
//  FriendTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 23.07.2021.
//

import UIKit
import Alamofire

class FriendTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak private var friendImage: UIImageView! {
        didSet {
            friendImage.layer.cornerRadius = friendImage.frame.size.height / 2
            friendImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak private var friendName: UILabel!
    @IBOutlet weak private var cityName: UILabel!
    //MARK: - Prefirence
    private let networkService = NetworkServiceInplimentation()
    //MARK: - Functions
    func configuration(currentFriend: Friend) {
        let tapRecognazer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        friendName.text = currentFriend.fullName
        cityName.text = currentFriend.cityName
        friendImage.image = currentFriend.imageAvatar
//        DispatchQueue.main.async {
//            self.networkService.getImageFromWeb(imageURL: currentFriend.urlAvatar ?? "", completion: { [weak self] imageAvatar in self?.friendImage.image = imageAvatar })
//        }
        friendImage.isUserInteractionEnabled = true
        friendImage.addGestureRecognizer(tapRecognazer)
    }
}

extension UITableViewCell {
    @objc func tapOnAvatar(tap: UITapGestureRecognizer){
        let tapImageView = tap.view as! UIImageView
        tapImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 10,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        tapImageView.transform = CGAffineTransform.identity
                       },
                       completion: nil)
    }
}
