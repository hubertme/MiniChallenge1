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
//    var obstacle = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // Declaration as self.childNode
        kite = self.childNode(withName: "kite") as! SKSpriteNode
//        obstacle = self.childNode(withName: "obstacle") as! SKSpriteNode
        
        kite.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
//        obstacle.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
        
//        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
//        border.friction = 0
//        border.restitution = 0.8
//        self.physicsBody = border
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        generateObstacle()
    }
    
    func generateObstacle(){
        print("ok")
        let posX = Int(arc4random_uniform(320))-180
        print(posX)
        
        let obstacles = SKShapeNode(rect: CGRect(x: posX, y: 220, width: 60, height: 150))
        obstacles.physicsBody? = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 100))
        obstacles.physicsBody?.isDynamic = true
        obstacles.physicsBody?.affectedByGravity = true
        obstacles.physicsBody?.usesPreciseCollisionDetection = true
        
        obstacles.fillColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        addChild(obstacles)
    }
}
