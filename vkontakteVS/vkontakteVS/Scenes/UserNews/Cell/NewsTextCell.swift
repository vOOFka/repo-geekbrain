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

protocol NewsTextCellSizes {
    var hightFullCell: CGFloat { get }
    var hightSmallCell: CGFloat { get }
    var moreTextButton: Bool { get }
}

class NewsTextCell: UITableViewCell {
    private var newsTextLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 17)
        return lable
    }()
    let moreTextButton = UIButton()
    weak var delegate: NewsTextCellDelegate?
    
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
        moreTextButton.isHidden = !cellParams.moreTextButton
    }
    
    // MARK: Actions
    @objc func tapMoreTextButton() {
        delegate?.newHeightCell(for: self)
    }
    
    fileprivate func configMoreTextButton() {
        moreTextButton.isUserInteractionEnabled = true
        moreTextButton.setTitle("Показать больше...", for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        moreTextButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .highlighted)
        moreTextButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        moreTextButton.addTarget(self, action: #selector(tapMoreTextButton), for: .touchUpInside)
        moreTextButton.backgroundColor = .white
    }
    
    private func setup() {
        contentView.addSubview(moreTextButton)
        contentView.addSubview(newsTextLabel)
        
        newsTextLabel.backgroundColor = .white
        contentView.backgroundColor = .white
        
        newsTextLabel.numberOfLines = 0
        newsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        moreTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        configMoreTextButton()
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            newsTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            newsTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            newsTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            moreTextButton.centerXAnchor.constraint(equalTo: newsTextLabel.centerXAnchor),
            moreTextButton.topAnchor.constraint(equalTo: newsTextLabel.bottomAnchor, constant: 0),
            moreTextButton.widthAnchor.constraint(equalTo: newsTextLabel.widthAnchor),
            moreTextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
