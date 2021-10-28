//
//  NewsImgGalleryTableViewCell.swift
//  vkontakteVS
//
//  Created by Home on 28.10.2021.
//

import UIKit

class NewsImgGalleryTableViewCell: UITableViewCell {

    var photos: [Attachments]?
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(NewsImgCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure (with photos: [Attachments]) {
        self.photos = photos
        collectionView.reloadData()
    }
    
}

extension NewsImgGalleryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NewsImgCollectionViewCell.self, for: indexPath)
        if photos != nil {
            cell.configure(with: photos![indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
}
