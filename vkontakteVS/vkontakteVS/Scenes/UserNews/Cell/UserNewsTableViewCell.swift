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
    var size: NewsCellSizes { get }
}

protocol NewsCellSizes {
    var newsTextFrame: CGRect { get }
    var newsImageFrame: CGRect { get }
    var hightCell: CGFloat { get }
}

class UserNewsTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateNewsLabel: UILabel!
    @IBOutlet weak var textNewsLabel: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        if cellView != nil { setup() }
    }
    
    //MARK: Functions
    func setNews(cellModel: NewsTableViewCellModel) {
        groupImageView.image = cellModel.group.image
        groupNameLabel.text = cellModel.group.name
        dateNewsLabel.text = cellModel.date
        textNewsLabel.text = cellModel.text
        imageNews.image = cellModel.image
        likesLabel.text = cellModel.likes
        commentsLabel.text = cellModel.comments
        repostLabel.text = cellModel.repost
        viewsLabel.text = cellModel.views
        
        textNewsLabel.frame = cellModel.size.newsTextFrame
        imageNews.frame = cellModel.size.newsImageFrame
    }
    
    private func setup() {
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
        
        groupImageView.layer.cornerRadius = 5
        groupImageView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
}
