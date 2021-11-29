//
//  Apple.swift
//  snakeVS
//
//  Created by Home on 12.07.2021.
//

import UIKit
import SpriteKit

class Apple: SKShapeNode {
    convenience init(position: CGPoint) {
        self.init()
        
        path = UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        fillColor = .red
        strokeColor = .red
        lineWidth = 3
        
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10.0, center: CGPoint(x: 5, y: 5))
        self.physicsBody?.categoryBitMask = CollisionCat.Appele
    }  
    
}
