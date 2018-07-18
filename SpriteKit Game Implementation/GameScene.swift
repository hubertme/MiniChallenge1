//
//  GameScene.swift
//  SpriteKit Game Implementation
//
//  Created by Hubert Wang on 18/07/18.
//  Copyright © 2018 Hubert Wang. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

var kite = SKSpriteNode()

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let kite: UInt32 = 0b1
    static let obstacles: UInt32 = 0b10
}

class GameScene: SKScene {
    
    let motionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(generateObstacle),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        kite = self.childNode(withName: "kite") as! SKSpriteNode
        
        kite.physicsBody?.collisionBitMask = PhysicsCategory.obstacles
        kite.physicsBody?.categoryBitMask = PhysicsCategory.kite
        kite.physicsBody?.contactTestBitMask = PhysicsCategory.obstacles
        kite.physicsBody?.restitution = 0.5
        
//        self.addChild(kite)
    }
    
    func generateObstacle(){
        let posX = Int(arc4random_uniform(320))-180
        let obstacles = SKSpriteNode(color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), size: CGSize(width: 10, height: 100))
        obstacles.position = CGPoint(x: posX, y: 420)
        obstacles.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 100))
        
        obstacles.physicsBody?.isDynamic = true
        obstacles.physicsBody?.collisionBitMask = PhysicsCategory.none
        obstacles.physicsBody?.categoryBitMask = PhysicsCategory.obstacles
        obstacles.physicsBody?.contactTestBitMask = PhysicsCategory.kite
        obstacles.physicsBody?.restitution = 0.5
        obstacles.physicsBody?.allowsRotation = true
        
        addChild(obstacles)
        
        let time = Int(arc4random_uniform(4))+2
        let actionMove = SKAction.move(to: CGPoint(x: posX, y: -1000), duration: TimeInterval(time))
        let actionMoveDone = SKAction.removeFromParent()
        obstacles.run(SKAction.sequence([actionMove,actionMoveDone]))
        
    }
    
    
//    override func viewDidAppear(_ animated: Bool){
//        motionManager
//    }
    
}
