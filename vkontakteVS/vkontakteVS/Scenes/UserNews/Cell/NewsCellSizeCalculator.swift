//
//  NewsCellSizeCalculator.swift
//  vkontakteVS
//
//  Created by Home on 07.08.2021.
//

import UIKit

struct CellParam: NewsTextCellSizes {
    var hightFullCell: CGFloat
    var hightSmallCell: CGFloat
    var moreTextButton: Bool
}

struct Constrains {
    static let cellViewInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    static let newsTextLabel = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    static let newsTextLabelFont = UIFont.systemFont(ofSize: 17)
    static let minimumNewsTextLabelLines: CGFloat = 3
}

final class NewsCellSizeCalculator {
    private let screenMinSize: CGFloat
    
    init() {
        self.screenMinSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    
    func hightTextCell(newsText: String?, showAllText: Bool) -> NewsTextCellSizes {
        let cellViewWidth = screenMinSize - Constrains.cellViewInsets.left - Constrains.cellViewInsets.right
        var cellFullHight = CGFloat(40.0)
        var cellSmallHight = CGFloat(20.0)
        var showMoreTextButton = showAllText
        
        if newsText != nil, newsText != "" {
            let width = cellViewWidth - Constrains.newsTextLabel.left - Constrains.newsTextLabel.right
            var height = newsText!.height(width: width, font: Constrains.newsTextLabelFont)
            let limitHeightLines = Constrains.newsTextLabelFont.lineHeight * Constrains.minimumNewsTextLabelLines
            cellFullHight = cellFullHight + height //FullSize
            
            if height > limitHeightLines && showAllText != true {
                height = Constrains.newsTextLabelFont.lineHeight * Constrains.minimumNewsTextLabelLines
                showMoreTextButton = true
                cellSmallHight = cellSmallHight + height //SmallSize
            }
        }
        return CellParam(hightFullCell: cellFullHight, hightSmallCell: cellSmallHight, moreTextButton: showMoreTextButton)
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
