//
//  SnakeHead.swift
//  snakeVS
//
//  Created by Home on 12.07.2021.
//

import UIKit

class SnakeHead: SnakeBodyPart {
    override init (atPoint point: CGPoint) {
        super.init(atPoint: point)
        
        self.physicsBody?.categoryBitMask = CollisionCat.SnakeHead
        self .physicsBody?.contactTestBitMask = CollisionCat.EdgeBody | CollisionCat.Appele | CollisionCat.Snake
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
