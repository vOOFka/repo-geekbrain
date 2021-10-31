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
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with currentAttachment: Attachments) {
        newsImageView.image = nil
        
        //Choice size download photo
        let size = sizeType.max
        guard let urlString = currentAttachment.photo?.sizes.first(where: { $0.type == size })!.urlPhoto,
              let urlImg =  URL(string: urlString) else { return }
        //self.newsImageView.kf.setImage(with: URL(string: url))
        
        loadIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            let imgFromUrl = try? Data(contentsOf: urlImg)
            sleep(1)
            DispatchQueue.main.async {
                if let imgData = imgFromUrl {
                    self.newsImageView.image = UIImage(data: imgData)
                }
                self.loadIndicator.stopAnimating()
            }
        }
    }

}
