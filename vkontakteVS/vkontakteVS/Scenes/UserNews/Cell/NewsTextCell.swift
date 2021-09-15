//
//  NewsTextCell.swift
//  vkontakteVS
//
//  Created by Admin on 09.09.2021.
//


import UIKit

protocol NewsTextCellDelegate: AnyObject {
    func newHeightCell(for cell: NewsTextCell)
}

class NewsTextCell: UITableViewCell {
    private let newsTextLabel = UILabel()
    private let moreTextButton = UIButton()
    weak var delegate: NewsTextCellDelegate?
    public var showMoreTextBtn = { }
    
    private struct Constrains {
        static let newsTextLabel = UIEdgeInsets(top: 80, left: 10, bottom: 10, right: 10)
        static let newsTextLabelFont = UIFont.systemFont(ofSize: 15)
        static let minimumNewsTextLabelLines: Int = 2
        static let moreTextButton = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }

//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    public func configuration(currentNews: News) {
        newsTextLabel.text = ""
        guard currentNews.text != "" else { return }
        newsTextLabel.text = currentNews.text
        
        addSubview(newsTextLabel)
        newsTextLabel.numberOfLines = 0
        newsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            newsTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            newsTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            newsTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        configMoreTextButton()
//        let height = newsTextLabel.text!.height(width: contentView.frame.size.width, font: Constrains.newsTextLabelFont)
//        let limitHeightLines = Constrains.newsTextLabelFont.lineHeight * CGFloat(Constrains.minimumNewsTextLabelLines)
//        if height > limitHeightLines {
//            newsTextLabel.numberOfLines = Constrains.minimumNewsTextLabelLines
//
//        }
//        self.layoutIfNeeded()
    }
    
    // MARK: Actions
    @objc func tapMoreTextButton() {
        print("More text")
        delegate?.newHeightCell(for: self)
    }
    
    fileprivate func configMoreTextButton() {
        moreTextButton.translatesAutoresizingMaskIntoConstraints = false
        moreTextButton.isUserInteractionEnabled = true
        moreTextButton.setTitle("Показать больше...", for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .highlighted)
        moreTextButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        addSubview(moreTextButton)
        moreTextButton.addTarget(self, action: #selector(tapMoreTextButton), for: .touchUpInside)
        moreTextButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        moreTextButton.backgroundColor = .orange
        
        NSLayoutConstraint.activate([
            moreTextButton.topAnchor.constraint(equalTo: newsTextLabel.bottomAnchor, constant: 10),
            moreTextButton.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
}
