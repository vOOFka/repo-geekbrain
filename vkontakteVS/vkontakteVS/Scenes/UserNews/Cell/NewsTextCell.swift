//
//  NewsTextCell.swift
//  vkontakteVS
//
//  Created by Admin on 09.09.2021.
//


import UIKit

protocol NewsTextCellDelegate: AnyObject {
    func newHeightCell(for cell: NewsTextCell)
   // func didTapButton(with title: String)
}

class NewsTextCell: UITableViewCell {
    private let newsTextLabel = UILabel()
    weak var delegate: NewsTextCellDelegate?
    public var showMoreTextBtn = { }
    
    private struct Constrains {
        static let cellViewInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        static let newsTextLabel = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let newsTextLabelFont = UIFont.systemFont(ofSize: 15)
        static let minimumNewsTextLabelLines: Int = 5
        static let moreTextButton = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }
    private var screenMinSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configuration(currentNews: News) {
        newsTextLabel.numberOfLines = 0
        newsTextLabel.text = ""
        guard currentNews.text != "" else { return }
        newsTextLabel.text = currentNews.text
        
        let cellViewWidth = screenMinSize - Constrains.cellViewInsets.left - Constrains.cellViewInsets.right
        let width = cellViewWidth - Constrains.newsTextLabel.left - Constrains.newsTextLabel.right
        var height = newsTextLabel.text!.height(width: width, font: Constrains.newsTextLabelFont)
                
        contentView.addSubview(newsTextLabel)
        
        let limitHeightLines = Constrains.newsTextLabelFont.lineHeight * CGFloat(Constrains.minimumNewsTextLabelLines)
        if height > limitHeightLines {
            newsTextLabel.numberOfLines = Constrains.minimumNewsTextLabelLines
            height = Constrains.newsTextLabelFont.lineHeight * CGFloat(Constrains.minimumNewsTextLabelLines)
            
        }
        newsTextLabel.frame = CGRect(x: 10, y: 0, width: width, height: height)
        configMoreTextButton()
        //        NSLayoutConstraint.activate([
        //            newsTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        //            newsTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        //            newsTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        //            newsTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        //        ])
        self.layoutIfNeeded()
    }
    
    // MARK: Actions
    @objc func tapMoreTextButton() {
        delegate?.newHeightCell(for: self)
    }
    
    fileprivate func configMoreTextButton() {
        let moreTextButton = UIButton()
        moreTextButton.isUserInteractionEnabled = true
        moreTextButton.setTitle("Показать больше...", for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .highlighted)
        moreTextButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        moreTextButton.addTarget(self, action: #selector(tapMoreTextButton), for: .touchUpInside)
        moreTextButton.backgroundColor = .orange
    //    moreTextButton.frame = CGRect(origin: CGPoint(x: Constrains.moreTextButton.left, y: newsTextLabel.frame.maxY), size: CGSize(width: 150, height: 15))
   
        contentView.addSubview(moreTextButton)
        
//        NSLayoutConstraint.activate([
//            moreTextButton.topAnchor.constraint(equalTo: topAnchor, constant: 50),//newsTextLabel.bottomAnchor, constant: 10),
//            moreTextButton.heightAnchor.constraint(equalToConstant: 30.0),
//            moreTextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
//        ])
    }
}
