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
    private let imageDownloader = ImageDownloader()

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
        downloadImage(url: app.screenshotUrls[indexPath.row], completion: { img in
            cell.configuration(with: img)
        })
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//           return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        }
    
    private func downloadImage(url: String, completion: @escaping (UIImage?) -> Void)  {
        self.imageDownloader.getImage(fromUrl: url) { (image, _) in
            completion(image)
        }
    }
}
