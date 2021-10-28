//
//  NewsImageCell.swift
//  vkontakteVS
//
//  Created by Admin on 10.09.2021.
//

import UIKit
import Kingfisher

class NewsImageCell: UITableViewCell {
    private var newsImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configuration(currentAttachment: Attachments) {
        newsImageView.image = nil
        newsImageView.contentMode = .scaleAspectFit
        newsImageView.translatesAutoresizingMaskIntoConstraints = false

        //Choice size download photo
        let size = sizeType.max
        guard let url = currentAttachment.photo?.sizes.first(where: { $0.type == size })!.urlPhoto else { return }
        newsImageView.kf.setImage(with: URL(string: url))
        
        if newsImageView.image != nil {
            let width = contentView.frame.width - 10 - 10
            let ratio: CGFloat = { newsImageView.image!.size.height / newsImageView.image!.size.width}()
            let hight = width * ratio
            
            NSLayoutConstraint.activate([
                newsImageView.heightAnchor.constraint(equalToConstant: hight)
            ])
        }
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }    

}
