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

var second = 0
var scoreLabel = SKLabelNode()
var isOver=false

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let kite: UInt32 = 0b1
    static let obstacles: UInt32 = 0b10
}

class GameScene: SKScene {
    let motionManager = CMMotionManager()
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        second = 0
        
        let action = SKAction.repeatForever(SKAction.sequence([SKAction.run(generateObstacle), SKAction.run(updateScore), SKAction.wait(forDuration: 1.0)]))
        run(action, withKey: "action")
        
        kite = self.childNode(withName: "kite") as! SKSpriteNode
        
        kite.physicsBody?.collisionBitMask = PhysicsCategory.obstacles
        kite.physicsBody?.categoryBitMask = PhysicsCategory.kite
        kite.physicsBody?.contactTestBitMask = PhysicsCategory.obstacles
        kite.physicsBody?.restitution = 0.5
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
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
    
    func updateScore(){
        second+=1
        print("\(second) s")
        scoreLabel.text = "\(second) s"
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsCategory.kite && contact.bodyB.categoryBitMask == PhysicsCategory.obstacles) {
            print("Hit!")
            isOver=true
            removeAction(forKey: "action")
            let gameOverLabel = SKLabelNode(fontNamed: "Helvetica")
            gameOverLabel.position = CGPoint(x: 0, y: 0)
            gameOverLabel.text = "Game Over :("
            gameOverLabel.fontColor = UIColor.white
            gameOverLabel.fontSize = 40
            gameOverLabel.alpha = 0
            UIView.animate(withDuration: 2) {
                gameOverLabel.alpha = 1
            }
            addChild(gameOverLabel)
        }
    }
}
