//
//  UserNewsTableViewCell.swift
//  vkontakteVS
//
//  Created by Admin on 05.08.2021.
//

import UIKit
protocol UserNewsTableViewCellDelegate: AnyObject {
    func newHeightCell(for cell: UserNewsTableViewCell)
}

protocol NewsTableViewCellModel {
    var id: Int { get }
    var date: String { get }
    var text: String? { get }
//    var image: UIImage? { get }
//    var likes: String { get }
//    var comments: String { get }
//    var repost: String { get }
//    var views: String { get }
 //   var size: NewsCellSizes { get set }
}

protocol NewsCellSizes {
    var newsTextFrame: CGRect { get }
    var newsImageFrame: CGRect { get }
    var hightCell: CGFloat { get }
    var moreTextButton: CGRect { get }
    
}

class UserNewsTableViewCell: UITableViewCell {
    // MARK: Vars
    weak var delegate: UserNewsTableViewCellDelegate?
    // MARK: Outlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateNewsLabel: UILabel!
    @IBOutlet weak var textNewsLabel: UILabel!
    @IBOutlet weak var moreTextButton: UIButton!
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
    func configuration(currentNews: News) {
        dateNewsLabel.text = String(currentNews.date)
        textNewsLabel.text = currentNews.text
    }
    
    func setNews(cellModel: NewsTableViewCellModel) {
        dateNewsLabel.text = String(cellModel.date)
        textNewsLabel.text = cellModel.text
//        imageNews.image = cellModel.image
//        likesLabel.text = cellModel.likes
//        commentsLabel.text = cellModel.comments
//        repostLabel.text = cellModel.repost
//        viewsLabel.text = cellModel.views
        
 //       textNewsLabel.frame = cellModel.size.newsTextFrame
 //       imageNews.frame = cellModel.size.newsImageFrame
 //       moreTextButton.frame = cellModel.size.moreTextButton
    }
    
    private func setup() {
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
        
        groupImageView.layer.cornerRadius = 5
        groupImageView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    // MARK: Actions
    @IBAction func tapMoreButton(_ sender: Any) {
        print("More text")
        delegate?.newHeightCell(for: self)
    }
}
