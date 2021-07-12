//
//  GameScene.swift
//  snakeVS
//
//  Created by Home on 12.07.2021.
//

import SpriteKit
import GameplayKit

struct CollisionCat {
    static let Snake:     UInt32 = 0x1 << 0 //0001 1
    static let SnakeHead: UInt32 = 0x1 << 1 //0010 2
    static let Appele:    UInt32 = 0x1 << 2 //0100 4
    static let EdgeBody:  UInt32 = 0x1 << 3 //1000 8
}

class GameScene: SKScene {

    var snake: Snake?
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.green
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false
        view.showsPhysics = true
        
        //Buttons
        let counterClockWiseButton = SKShapeNode()
        counterClockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath
        counterClockWiseButton.position = CGPoint(x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30)
        counterClockWiseButton.fillColor = UIColor.yellow
        counterClockWiseButton.strokeColor = UIColor.black
        counterClockWiseButton.lineWidth = 3
        counterClockWiseButton.name = "counterClockWiseButton"
        self.addChild(counterClockWiseButton)
        
        let clockWiseButton = SKShapeNode()
        clockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath
        clockWiseButton.position = CGPoint(x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY + 30)
        clockWiseButton.fillColor = UIColor.yellow
        clockWiseButton.strokeColor = UIColor.black
        clockWiseButton.lineWidth = 3
        clockWiseButton.name = "clockWiseButton"
        self.addChild(clockWiseButton)
        
        createApple()
        
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        self.addChild(snake!)
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody?.categoryBitMask = CollisionCat.EdgeBody
        self.physicsBody?.collisionBitMask = CollisionCat.Snake | CollisionCat.SnakeHead
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let toucheLocation = touch.location(in: self)
            guard let touchNode = self.atPoint(toucheLocation) as? SKShapeNode,
                  touchNode.name == "counterClockWiseButton" || touchNode.name == "clockWiseButton" else {
                return
            }
            touchNode.fillColor = .darkGray
            
            if touchNode.name == "counterClockWiseButton" {
                snake!.moveCounterClockWise()
            } else {
                snake!.moveClockWise()
            }
    
        }
        //createApple()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let toucheLocation = touch.location(in: self)
            guard let touchNode = self.atPoint(toucheLocation) as? SKShapeNode,
                  touchNode.name == "counterClockWiseButton" || touchNode.name == "clockWiseButton" else {
                return
            }
            touchNode.fillColor = .yellow
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        snake!.move()
    }
    
    func createApple() {
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 20)))
        var randY = CGFloat()
        
        repeat {
            randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 50)))
        } while randY <= (view!.scene!.frame.minY + 90)
        
    
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        print("X:\(randX) Y:\(randY)")
        self.addChild(apple)
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        let collisionObj = bodyes - CollisionCat.SnakeHead
        
        switch collisionObj {
        case CollisionCat.Appele:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            createApple()
        case CollisionCat.EdgeBody:
            //resetGame()
            displayGameOver()
//        case CollisionCat.Snake:
//            let snakeBody = contact.bodyA.node is SnakeBodyPart ? contact.bodyA.node : contact.bodyB.node
//            if snakeBody is SnakeBodyPart {
//                resetGame()
//            }
//            print("oooooops")
//            break
        default:
            break
        }
    }
    
    func resetGame() {
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size)
        let transition = SKTransition.fade(withDuration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    
    func displayGameOver() {

        let gameOverScene = GameOverScene(size: size)
        gameOverScene.scaleMode = scaleMode

        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: reveal)
    }
}
