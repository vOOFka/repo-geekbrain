//
//  NewsTextCell.swift
//  vkontakteVS
//
//  Created by Admin on 09.09.2021.
//


import UIKit

class NewsTextCell: UITableViewCell {
    private let newsTextLabel = UILabel()
    private let moreTextButton = UIButton()
    
    private struct Constrains {
        static let newsTextLabel = UIEdgeInsets(top: 80, left: 10, bottom: 10, right: 10)
        static let newsTextLabelFont = UIFont.systemFont(ofSize: 15)
        static let minimumNewsTextLabelLines: Int = 2
        static let moreTextButton = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        moreTextButton.setTitle("Показать больше...", for: .normal)
        moreTextButton.backgroundColor = UIColor.random()
        addSubview(newsTextLabel)
        addSubview(moreTextButton)
        
        newsTextLabel.numberOfLines = 0
//        newsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        moreTextButton.frame.size = CGSize.zero
        moreTextButton.isHidden = true
//        moreTextButton.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            newsTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            newsTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//          //  newsTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//            newsTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
//
//            ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configuration(currentNews: News) {
        newsTextLabel.text = ""
        guard currentNews.text != "" else { return }
       // contentView.addSubview(newsTextLabel)
        newsTextLabel.text = currentNews.text
        
        var newsTextLabelFrame = CGRect(origin: CGPoint(x: Constrains.newsTextLabel.left,
                                                    y: Constrains.newsTextLabel.top),
                                                    size: CGSize.zero)
        var moreTextButtonFrame = CGRect(origin: CGPoint(x: Constrains.moreTextButton.left,
                                                       y: Constrains.moreTextButton.top),
                                                       size: CGSize.zero)
        
        let height = newsTextLabel.text!.height(width: contentView.frame.size.width, font: Constrains.newsTextLabelFont)
        let limitHeightLines = Constrains.newsTextLabelFont.lineHeight * CGFloat(Constrains.minimumNewsTextLabelLines)
        if height > limitHeightLines {
            newsTextLabelFrame.size = CGSize(width: contentView.frame.size.width, height: height)
            newsTextLabel.frame = newsTextLabelFrame
            
            newsTextLabel.numberOfLines = Constrains.minimumNewsTextLabelLines
            moreTextButton.frame.size = CGSize(width: contentView.frame.size.width, height: 15)
            moreTextButton.isHidden = false
            
//            newsTextLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
//
//            NSLayoutConstraint.activate([
//                moreTextButton.topAnchor.constraint(equalTo: newsTextLabel.bottomAnchor, constant: 10),
//                moreTextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//                moreTextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//                moreTextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
//                ])
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//       // let width = cellViewWidth - Constrains.newsTextLabel.left - Constrains.newsTextLabel.right
//        var height = newsTextLabel.text!.height(width: contentView.frame.size.width, font: Constrains.newsTextLabelFont)
//
//        if newsTextLabel.text != nil, newsTextLabel.text != "" {
//
//            let limitHeightLines = Constrains.newsTextLabelFont.lineHeight * Constrains.minimumNewsTextLabelLines
//
//            if height > limitHeightLines {//&& showAllText != true {
//                height = Constrains.newsTextLabelFont.lineHeight * Constrains.minimumNewsTextLabelLines
//                //showMoreTextButton = true
//            }
//           // newsLabelFrame.size = CGSize(width: width, height: height)
//           // cellHight = cellHight + height
//        }
//        newsTextLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: height)
        
 //   }
}
