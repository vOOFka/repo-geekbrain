//
//  NewsTextCell.swift
//  vkontakteVS
//
//  Created by Admin on 09.09.2021.
//


import UIKit

class NewsTextCell: UITableViewCell {
    private let newsTextLabel = UILabel()
    
    public func configuration(currentNews: News) {
        guard currentNews.text != "" else { return }
        contentView.addSubview(newsTextLabel)
        newsTextLabel.text = currentNews.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTextLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        newsTextLabel.numberOfLines = 0
    }
}
