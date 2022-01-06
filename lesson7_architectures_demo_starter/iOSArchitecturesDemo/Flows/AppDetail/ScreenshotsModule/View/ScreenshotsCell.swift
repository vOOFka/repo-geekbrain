//
//  ScreenshotsCell.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 04.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

class ScreenshotsCell: UICollectionViewCell {
    
    private(set) lazy var screenshotImageView: WebImageView = {
        let image = WebImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
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
    
    func configuration(with url: String?) {
        screenshotImageView.setImage(url: url)
    }

    private func setupLayout() {
        self.addSubview(self.screenshotImageView)
        NSLayoutConstraint.activate([
            self.screenshotImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            self.screenshotImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.screenshotImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            self.screenshotImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0),
            self.screenshotImageView.heightAnchor.constraint(equalToConstant: 150.0)
        ])
    }
}
