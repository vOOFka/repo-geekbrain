//
//  NewsFooter.swift
//  vkontakteVS
//
//  Created by Home on 08.09.2021.
//

import UIKit

class NewsFooter: UITableViewHeaderFooterView {
    @IBOutlet weak private var likesLabel: UILabel!
    @IBOutlet weak private var commentsLabel: UILabel!
    @IBOutlet weak private var repostLabel: UILabel!
    @IBOutlet weak private var viewsLabel: UILabel!
    @IBOutlet weak private var footerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        footerView.backgroundColor = .white
        footerView.layer.cornerRadius = 10
        footerView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(with currentNews: News) {
        commentsLabel.text = formatPoints(from: currentNews.comments)
        likesLabel.text = formatPoints(from: currentNews.likes)
        repostLabel.text = formatPoints(from: currentNews.reposts)
        viewsLabel.text = formatPoints(from: currentNews.views)
    }
    
    private func formatPoints(from: Int) -> String {
        let number = Double(from)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        
        if billion >= 1.0 {
            return "\(round(billion*10)/10)B"
        } else if million >= 1.0 {
            return "\(round(million*10)/10)M"
        } else if thousand >= 1.0 {
            return ("\(round(thousand*10/10))K")
        } else {
            return "\(Int(number))"
        }
    }
}
