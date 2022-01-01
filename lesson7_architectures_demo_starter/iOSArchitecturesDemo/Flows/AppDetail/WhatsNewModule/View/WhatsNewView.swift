//
//  WhatsNewView.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 01.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class WhatsNewView: UIView {

    // MARK: - Subviews

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Что нового:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()

    private(set) lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var whatsNewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayout()
    }

    // MARK: - UI

    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.versionLabel)
        self.addSubview(self.releaseDateLabel)
        self.addSubview(self.whatsNewLabel)

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.titleLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: -16.0),
            
            self.versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            self.versionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            
            self.releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            self.releaseDateLabel.leftAnchor.constraint(greaterThanOrEqualTo: versionLabel.rightAnchor, constant: 16.0),
            self.releaseDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            
            self.whatsNewLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20.0),
            self.whatsNewLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.whatsNewLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            self.whatsNewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0)
        ])
    }

}
