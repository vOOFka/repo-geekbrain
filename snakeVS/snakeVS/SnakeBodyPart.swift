//
//  SnakeBodyPart.swift
//  snakeVS
//
//  Created by Home on 12.07.2021.
//

import UIKit
import SpriteKit

class SnakeBodyPart: SKShapeNode {
    let diametr = 10
    
    init(atPoint point: CGPoint) {
        super.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        fillColor = .darkGray
        strokeColor = .darkGray
        lineWidth = 5
        self.position = point
        
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(diametr), center: CGPoint(x: 5, y: 5))
        
        self.physicsBody?.categoryBitMask = CollisionCat.Snake
        self.physicsBody?.contactTestBitMask = CollisionCat.EdgeBody | CollisionCat.Appele
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
