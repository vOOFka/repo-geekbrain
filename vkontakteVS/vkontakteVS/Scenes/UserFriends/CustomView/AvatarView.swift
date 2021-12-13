//
//  AvatarView.swift
//  vkontakteVS
//
//  Created by Home on 29.07.2021.
//

import UIKit

//@IBDesignable
class AvatarView: UIView {
    
    private var size = CGSize()
    @IBInspectable var shadowSize: CGFloat = 8 {
        didSet {
            size = CGSize(width: shadowSize, height: shadowSize)
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .myBlack
    @IBInspectable var shadowOpacity: Float = 0.8
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = size
        layer.shadowOpacity = shadowOpacity / 10
        layer.shadowRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
}
