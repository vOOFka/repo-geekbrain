//
//  ScreenshotsView.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 04.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

class ScreenshotsView: UIView {
    
    var collectionView: UICollectionView!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            layout.estimatedItemSize = CGSize(width: 150.0, height: 150.0)
            layout.minimumInteritemSpacing = 5.0
            return layout
        }()
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addCollectionView()
        self.setupConstraints()
    }
    
    private func addCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 150.0)
            ])
    }
}
