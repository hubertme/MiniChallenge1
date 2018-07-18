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
    var obstacle = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // Declaration as self.childNode
        kite = self.childNode(withName: "kite") as! SKSpriteNode
        obstacle = self.childNode(withName: "obstacle") as! SKSpriteNode
        
        kite.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
        obstacle.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
        
//        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
//        border.friction = 0
//        border.restitution = 0.8
//        self.physicsBody = border
    }
    
    override func update(_ currentTime: TimeInterval) {
        print("Hi")
    }
    
    func generateObstacle(){
//        let obstacles = self.childNode(withName: "obstacles") as! SKSpriteNode
        var obstacles = SKSpriteNode()
        let posX = arc4random_uniform(320)-160
//        obstacle.physicsBody?.
//        obstacles = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 100), center: CGPoint(x: CGFloat(posX), y: 420))
    }
}
