//
//  NewsImageCell.swift
//  vkontakteVS
//
//  Created by Admin on 10.09.2021.
//

import UIKit
import Kingfisher

class NewsImageCell: UITableViewCell {
    private let newsImageView = UIImageView()
    
    public func configuration(currentNews: News) {
        newsImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        contentView.addSubview(newsImageView)
        //Choice size download photo
        let size = sizeType.mid
        guard let url = currentNews.attachments?[0].photo?.sizes.first(where: { $0.type == size })!.urlPhoto else { return }
        newsImageView.kf.setImage(with: URL(string: url))
    }

}
