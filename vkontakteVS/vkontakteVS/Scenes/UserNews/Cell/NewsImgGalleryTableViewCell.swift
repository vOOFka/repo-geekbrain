//
//  NewsImgGalleryTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 28.10.2021.
//

import UIKit

class NewsImgGalleryTableViewCell: UITableViewCell {

    private var photosURLs = [String]()
    private var photosRatios = [CGFloat]()
    @IBOutlet private var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(NewsImgCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        let sections = collectionView.numberOfSections
        if sections >= 0 {
            let items = collectionView.numberOfItems(inSection: 0)
            if items > 0 {
                collectionView.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
            }
        }
    }
    
    public func configuration(for photosURLs: [String], with photosRatios: [CGFloat]) {
        self.photosURLs = photosURLs
        self.photosRatios = photosRatios
        collectionView.reloadData()
    }
}

extension NewsImgGalleryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NewsImgCollectionViewCell.self, for: indexPath)
        cell.configuration(for: photosURLs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = CGFloat(300)
        let width = collectionView.frame.width
        let height = photosRatios[indexPath.row] * width
        return CGSize(width: width, height: height)
    }
    
}
