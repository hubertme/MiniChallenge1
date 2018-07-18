//
//  GameScene.swift
//  SpriteKit Game Implementation
//
//  Created by Hubert Wang on 18/07/18.
//  Copyright © 2018 Hubert Wang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var kite = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        kite = self.childNode(withName: "kite") as! SKSpriteNode
        kite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(generateObstacle),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func generateObstacle(){
        let posX = Int(arc4random_uniform(320))-180
        
        let obstacles = SKShapeNode(rect: CGRect(x: posX, y: 220, width: 60, height: 150))
        obstacles.physicsBody? = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 100))
        obstacles.physicsBody?.isDynamic = true
        obstacles.physicsBody?.affectedByGravity = true
        obstacles.physicsBody?.usesPreciseCollisionDetection = true
        
        obstacles.fillColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        addChild(obstacles)
        
        let time = Int(arc4random_uniform(4))+2
        let actionMove = SKAction.move(to: CGPoint(x: 0, y: -1000), duration: TimeInterval(time))
        let actionMoveDone = SKAction.removeFromParent()
        obstacles.run(SKAction.sequence([actionMove,actionMoveDone]))
    }
}
