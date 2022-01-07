//
//  MusicDetailView.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class MusicDetailView: UIView {
    
    // MARK: - Subviews
    
    let imageView = UIImageView()
    let progressView = UIProgressView()
    let playButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addImageView()
        self.addProgressView()
        self.addPlayButton()
        self.setupConstraints()
    }
    
    private func addImageView() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.imageView.layer.cornerRadius = 10.0
        self.imageView.layer.masksToBounds = true
        self.addSubview(self.imageView)
    }
    
    private func addProgressView() {
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.progressView.progress = 0.0
        self.addSubview(self.progressView)
    }
    
    private func addPlayButton() {
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.playButton.backgroundColor = .orange
        self.playButton.layer.cornerRadius = 10.0
        self.playButton.layer.masksToBounds = true
        self.playButton.setTitleColor(.white, for: .normal)
        self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        self.addSubview(self.playButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: 100.0),
            self.imageView.heightAnchor.constraint(equalToConstant: 100.0),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -200.0),
            
            self.progressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0),
            self.progressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0),
            self.progressView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50.0),
            
            self.playButton.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            self.playButton.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: 100.0),
            self.playButton.widthAnchor.constraint(equalToConstant: 50.0),
            self.playButton.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }

}
