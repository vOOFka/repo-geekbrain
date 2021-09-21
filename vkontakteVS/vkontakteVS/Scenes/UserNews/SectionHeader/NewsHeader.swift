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
    //MARK: - Functions
    func configuration(currentNews: News, currentGroupNews: Group?) {
        let date = Date.init(timeIntervalSince1970: TimeInterval(currentNews.date))
        let dateFormater: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "MM-dd-yyyy HH:mm"
            df.timeZone = NSTimeZone.local
            return df
        }()
        dateNewsLabel.text = dateFormater.string(from: date)
        //Other fields
        guard let group = currentGroupNews,
              let url = group.urlPhoto else { return }
        groupImageView.kf.setImage(with: URL(string: url))
        groupNameLabel.text = group.name
        
    }
}
