//
//  NewsHeader.swift
//  vkontakteVS
//
//  Created by Home on 08.09.2021.
//

import UIKit
import Kingfisher

class NewsHeader: UITableViewHeaderFooterView {
    @IBOutlet weak private var groupImageView: UIImageView!
    @IBOutlet weak private var groupNameLabel: UILabel!
    @IBOutlet weak private var dateNewsLabel: UILabel!
    @IBOutlet weak private var headerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerView.backgroundColor = .white
        headerView.layer.cornerRadius = 10
        headerView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Functions
    public func configuration(currentNews: News, currentGroupNews: Group?) {
        dateNewsLabel.text = currentNews.dateFormatted
        //Other fields
        guard let group = currentGroupNews,
              let url = group.urlPhoto else { return }
        groupImageView.kf.setImage(with: URL(string: url))
        groupNameLabel.text = group.name
    }
}
