//
//  ScreenshotsController.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 04.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ScreenshotsCell"

final class ScreenshotsController: UIViewController {
    
    // MARK: - Properties
    private var screenshotsView: ScreenshotsView {
        return self.view as! ScreenshotsView
    }
    
    private let app: ITunesApp

    // MARK: - Init
    override func loadView() {
        super.loadView()
        self.view = ScreenshotsView()
    }
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenshotsView.collectionView.register(ScreenshotsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.screenshotsView.collectionView.delegate = self
        self.screenshotsView.collectionView.dataSource = self
    }
    
}

extension ScreenshotsController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app.screenshotUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ScreenshotsCell
        else {
            return UICollectionViewCell()
        }
        cell.configuration(with: app.screenshotUrls[indexPath.row])
        return cell
    }
}
