//
//  NewsImgCollectionViewCell.swift
//  vkontakteVS
//
//  Created by Home on 28.10.2021.
//

import UIKit
import Kingfisher

class NewsImgCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var newsImageView: UIImageView!
    @IBOutlet weak private var loadIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public func configuration(for urlString: String) {
        newsImageView.image = nil
        guard let urlImg =  URL(string: urlString) else { return }
        //self.newsImageView.kf.setImage(with: URL(string: urlString))        
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
