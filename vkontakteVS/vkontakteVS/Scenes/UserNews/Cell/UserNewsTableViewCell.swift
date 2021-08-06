//
//  UserNewsTableViewCell.swift
//  vkontakteVS
//
//  Created by Admin on 05.08.2021.
//

import UIKit

protocol NewsTableViewCellModel {
    var group: Group { get }
    var date: String { get }
    var text: String? { get }
    var image: UIImage? { get }
    var likes: String { get }
    var comments: String { get }
    var repost: String { get }
    var views: String { get }
}

class UserNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconGroupImageView: UIImageView!
    @IBOutlet weak var nameGroupLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textNewsLabel: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostLabel: UILabel!    
    @IBOutlet weak var viewsLabel: UILabel!
    
    
    func setNews(cellModel: NewsTableViewCellModel) {
        iconGroupImageView.image = cellModel.group.image
        nameGroupLabel.text = cellModel.group.name
        dateLabel.text = cellModel.date
        textNewsLabel.text = cellModel.text
        imageNews.image = cellModel.image
        likesLabel.text = cellModel.likes
        commentsLabel.text = cellModel.comments
        repostLabel.text = cellModel.repost
        viewsLabel.text = cellModel.views
    }
    
}
