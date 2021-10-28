//
//  NewsTextCell.swift
//  vkontakteVS
//
//  Created by Admin on 09.09.2021.
//


import UIKit
import SwiftUI

protocol NewsTextCellDelegate: AnyObject {
    func newHeightCell(for cell: NewsTextCell)
   // func didTapButton(with title: String)
}

class NewsTextCell: UITableViewCell {
    private let newsTextLabel = UILabel()
    weak var delegate: NewsTextCellDelegate?
    public var showMoreTextBtn = { }
    
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
              
        contentView.addSubview(newsTextLabel)
        let height = NewsCellSizeCalculator().hightTextCell(newsText: currentNews.text)
        newsTextLabel.frame = CGRect(x:10, y: 10, width: contentView.frame.size.width - 20, height: height)
        
  //      configMoreTextButton(currentNews: currentNews)
    }
    
    // MARK: Actions
    @objc func tapMoreTextButton() {
        delegate?.newHeightCell(for: self)
    }
    
    fileprivate func configMoreTextButton(currentNews: News) {
        let moreTextButton = UIButton()
        moreTextButton.isUserInteractionEnabled = true
        moreTextButton.setTitle("Показать больше...", for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .highlighted)
        moreTextButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        moreTextButton.addTarget(self, action: #selector(tapMoreTextButton), for: .touchUpInside)
        moreTextButton.backgroundColor = .orange
        moreTextButton.frame = currentNews.sizes!.moreTextButton
   
        contentView.addSubview(moreTextButton)
    }
}
