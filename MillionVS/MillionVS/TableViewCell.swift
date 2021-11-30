//
//  TableViewCell.swift
//  MillionVS
//
//  Created by Home on 30.11.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    private var questionLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 17)
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        questionLabel.text = ""
    }
    
    public func configuration(for question: String) {
        questionLabel.text = question
    }

    private func setup() {
        contentView.addSubview(questionLabel)
        
        questionLabel.backgroundColor = .white
        contentView.backgroundColor = .white
        
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            questionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
}
