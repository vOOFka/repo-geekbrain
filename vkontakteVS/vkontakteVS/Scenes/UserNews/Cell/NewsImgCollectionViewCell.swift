//
//  NewsImgCollectionViewCell.swift
//  vkontakteVS
//
//  Created by Home on 28.10.2021.
//

import UIKit
import Kingfisher

class NewsImgCollectionViewCell: UICollectionViewCell {

    @IBOutlet var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with currentAttachment: Attachments) {
        newsImageView.image = nil
        
        //Choice size download photo
        let size = sizeType.max
        guard let url = currentAttachment.photo?.sizes.first(where: { $0.type == size })!.urlPhoto else { return }
        self.newsImageView.kf.setImage(with: URL(string: url))
    }

}
