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
    var moreTextButton: CGRect
}

struct Constrains {
    static let cellViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let hightCellView: CGFloat = 175 //defalt cell hight
    static let newsTextLabel = UIEdgeInsets(top: 80, left: 10, bottom: 10, right: 10)
    static let newsTextLabelFont = UIFont.systemFont(ofSize: 15)
    static let newsImage = UIEdgeInsets(top: 110, left: 10, bottom: 10, right: 10)
    static let minimumNewsTextLabelLines: CGFloat = 5
    static let moreTextButton = UIEdgeInsets(top: 100, left: 10, bottom: 0, right: 0)
}

final class NewsCellSizeCalculator {
    private let screenMinSize: CGFloat
    
    init() {
        self.screenMinSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }

    func sizes(newsText: String?, newsImage: UIImage?, showAllText: Bool) -> NewsCellSizes {
        let cellViewWidth = screenMinSize - Constrains.cellViewInsets.left - Constrains.cellViewInsets.right
        
        var newsLabelFrame = CGRect(origin: CGPoint(x: Constrains.newsTextLabel.left,
                                                    y: Constrains.newsTextLabel.top),
                                                    size: CGSize.zero)
        var newsImageFrame = CGRect(origin: CGPoint(x: Constrains.newsImage.left,
                                                    y: Constrains.newsImage.top),
                                                    size: CGSize.zero)
        var moreTextButtonFrame = CGRect(origin: CGPoint(x: Constrains.moreTextButton.left,
                                                       y: Constrains.moreTextButton.top),
                                                       size: CGSize.zero)
        var showMoreTextButton = false
        var cellHight = Constrains.hightCellView //175
        
        if newsText != nil, newsText != "" {
            let width = cellViewWidth - Constrains.newsTextLabel.left - Constrains.newsTextLabel.right
            var height = newsText!.height(width: width, font: Constrains.newsTextLabelFont)
            let limitHeightLines = Constrains.newsTextLabelFont.lineHeight * Constrains.minimumNewsTextLabelLines
            
            if height > limitHeightLines && showAllText != true {
                height = Constrains.newsTextLabelFont.lineHeight * Constrains.minimumNewsTextLabelLines
                showMoreTextButton = true
            }
            newsLabelFrame.size = CGSize(width: width, height: height)
            cellHight = cellHight + height
        }
        
        if showMoreTextButton {
            moreTextButtonFrame = CGRect(origin: CGPoint(x: Constrains.moreTextButton.left, y: newsLabelFrame.maxY), size: CGSize(width: 150, height: 15))
        }
        
        if newsImage != nil {
            let width = cellViewWidth - Constrains.newsImage.left - Constrains.newsImage.right
            let ratio: CGFloat = { newsImage!.size.height / newsImage!.size.width}()
            let hight = width * ratio
            let delta = showAllText ? newsLabelFrame.maxY : moreTextButtonFrame.maxY
            
            newsImageFrame = CGRect(origin: CGPoint(x: Constrains.newsImage.left,
                                                  y: Constrains.newsTextLabel.bottom + delta),
                                         size: CGSize(width: width, height: hight))
            cellHight = cellHight + hight
        }
                
        return Size(newsTextFrame: newsLabelFrame, newsImageFrame: newsImageFrame, hightCell: cellHight, moreTextButton: moreTextButtonFrame)
    }
}

extension String {
    //Calculate hight String from Font size
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize (width: width, height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        return ceil(size.height)
    }
}
