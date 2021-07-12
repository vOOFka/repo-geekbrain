//
//  GameOverScene.swift
//  snakeVS
//
//  Created by Home on 12.07.2021.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {

    var label = SKLabelNode(text: "Game Over")
    var label2 = SKLabelNode(text: "tap for RESET")

    override init(size: CGSize) {
        super.init(size: size)

        self.backgroundColor = .gray

        addChild(label)
        label.fontSize = 32.0
        label.color = .white
        label.fontName = "Thonburi-Bold"
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        addChild(label2)
        label2.fontName = "Thonburi-Bold"
        label2.position = CGPoint(x: label.position.x,
                                              y: label.position.y - 40)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode

        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameScene, transition: reveal)
    }
}
