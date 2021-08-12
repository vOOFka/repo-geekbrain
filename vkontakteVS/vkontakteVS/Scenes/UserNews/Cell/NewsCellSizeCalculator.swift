//
//  NewsCellSizeCalculator.swift
//  vkontakteVS
//
//  Created by Home on 07.08.2021.
//

import UIKit

struct Size: NewsCellSizes {
    var newsTextFrame: CGRect
    var newsImageFrame: CGRect
    var hightCell: CGFloat
}

struct Constrains {
    static let cellViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let hightCellView: CGFloat = 175 //defalt cell hight
    static let newsTextLabel = UIEdgeInsets(top: 80, left: 10, bottom: 10, right: 10)
    static let newsTextLabelFont = UIFont.systemFont(ofSize: 15)
    static let newsImage = UIEdgeInsets(top: 120, left: 10, bottom: 10, right: 10)
}

final class NewsCellSizeCalculator {
    private let screenMinSize: CGFloat
    
    init() {
        self.screenMinSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }

    func sizes(newsText: String?, newsImage: UIImage?) -> NewsCellSizes {
        let cellViewWidth = screenMinSize - Constrains.cellViewInsets.left - Constrains.cellViewInsets.right
        
        var newsLabelFrame = CGRect(origin: CGPoint(x: Constrains.newsTextLabel.left,
                                                    y: Constrains.newsTextLabel.top),
                                                    size: CGSize.zero)
        var newsImageFrame = CGRect(origin: CGPoint(x: Constrains.newsImage.left,
                                                    y: Constrains.newsImage.top),
                                                    size: CGSize.zero)
        var cellHight = Constrains.hightCellView //175
        
        if newsText != nil, newsText != "" {
            let width = cellViewWidth - Constrains.newsTextLabel.left - Constrains.newsTextLabel.right
            let hight = newsText!.height(width: width, font: Constrains.newsTextLabelFont)
            
            newsLabelFrame.size = CGSize(width: width, height: hight)
            cellHight = cellHight + hight
        }
        
        if newsImage != nil {
            let width = cellViewWidth - Constrains.newsImage.left - Constrains.newsImage.right
            let ratio: CGFloat = { newsImage!.size.height / newsImage!.size.width}()
            let hight = width * ratio
            
            newsImageFrame = CGRect(origin: CGPoint(x: Constrains.newsImage.left,
                                                    y: Constrains.newsTextLabel.bottom + newsLabelFrame.maxY),
                                         size: CGSize(width: width, height: hight))
            cellHight = cellHight + hight
        }
                
        return Size(newsTextFrame: newsLabelFrame, newsImageFrame: newsImageFrame, hightCell: cellHight)
    }
}

extension String {
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize (width: width, height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        return ceil(size.height)
    }
}
