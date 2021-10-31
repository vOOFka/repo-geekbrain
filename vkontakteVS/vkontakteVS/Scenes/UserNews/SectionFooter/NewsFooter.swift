//
//  NewsFooter.swift
//  vkontakteVS
//
//  Created by Home on 08.09.2021.
//

import UIKit

class NewsFooter: UITableViewHeaderFooterView {
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    public func configure(with currentNews: News) {
        commentsLabel.text = formatPoints(from: currentNews.comments)
        likesLabel.text = formatPoints(from: currentNews.likes)
        repostLabel.text = formatPoints(from: currentNews.reposts)
        viewsLabel.text = formatPoints(from: currentNews.views)
    }
    
    func formatPoints(from: Int) -> String {

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
