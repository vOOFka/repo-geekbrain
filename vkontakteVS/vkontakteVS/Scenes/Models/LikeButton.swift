//
//  LikeButton.swift
//  vkontakteVS
//
//  Created by Home on 01.08.2021.
//

import UIKit

class LikeButton: UIButton {
    var likeState = false {
        didSet {
            setNeedsDisplay()
        }
    }
    private var color = UIColor.white
    private let path = Like.shape
    
    override func draw(_ rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        let scale = CGSize(width: (bounds.size.width) / path.bounds.size.width, height: (bounds.size.height) / path.bounds.size.height)
        
        path.apply(CGAffineTransform(scaleX: scale.width, y: scale.height))
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        if likeState == true {
            color = UIColor.red
        } else {
            color = UIColor.white
        }        
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let pointpath: UIBezierPath? = path
        if let path = pointpath {
            return path.contains(point)
        }
        return false
    }
    
}
