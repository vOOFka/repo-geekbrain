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

protocol NewsTextCellSizes {
    var hightCell: CGFloat { get }
    var moreTextButton: Bool { get }
}

class NewsTextCell: UITableViewCell {
    private let newsTextLabel = UILabel()
    weak var delegate: NewsTextCellDelegate?
    public var showMoreTextBtn = { }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        newsTextLabel.text = ""
    }
    
    public func configuration(for currentNewsText: String, with cellParams: NewsTextCellSizes?) {
        newsTextLabel.text = currentNewsText
        guard let cellParams = cellParams else { return }
        //configMoreTextButton(cellParams) 
    }
    
    // MARK: Actions
    @objc func tapMoreTextButton() {
        delegate?.newHeightCell(for: self)
    }
    
    fileprivate func configMoreTextButton(_ cellParams: NewsTextCellSizes) {
        let moreTextButton = UIButton()
        moreTextButton.isUserInteractionEnabled = true
        moreTextButton.setTitle("Показать больше...", for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .highlighted)
        moreTextButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        moreTextButton.addTarget(self, action: #selector(tapMoreTextButton), for: .touchUpInside)
        moreTextButton.backgroundColor = .orange
        contentView.addSubview(moreTextButton)
        NSLayoutConstraint.activate([
            moreTextButton.topAnchor.constraint(equalTo: newsTextLabel.topAnchor, constant: 10),
            moreTextButton.leadingAnchor.constraint(equalTo: newsTextLabel.leadingAnchor, constant: 10),
            moreTextButton.bottomAnchor.constraint(equalTo: newsTextLabel.bottomAnchor, constant: -10),
            moreTextButton.trailingAnchor.constraint(equalTo: newsTextLabel.trailingAnchor, constant: -10)
        ])
    }
    
    private func setup() {
        contentView.addSubview(newsTextLabel)
        newsTextLabel.backgroundColor = .white
        newsTextLabel.numberOfLines = 0
        newsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 30),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            newsTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            newsTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            newsTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
