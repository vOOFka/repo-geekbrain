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
    
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowOpacity: Float = 0.8
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = size
        layer.shadowOpacity = shadowOpacity / 10
        layer.shadowRadius = 8
        
      //  layer.mask = drawMask()
    }
    
//    func drawMask () -> CAShapeLayer {
//        let shapeLayer = CAShapeLayer()
//
//        shapeLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath
//        return shapeLayer
//    }

}
