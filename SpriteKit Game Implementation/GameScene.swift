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

extension Array {
    func randomElement() -> Element  {
    
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}
var kite = SKSpriteNode()

var second = 0
var scoreLabel = SKLabelNode()
var isOver=true

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let kite: UInt32 = 0b1
    static let obstacles: UInt32 = 0b10
}

class GameScene: SKScene {
    
   
    let arrayClouds = ["clouds1","clouds3","clouds4","clouds5","clouds9","clouds7"]
    
    let motionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        second = 0
        isOver=false
        
        let action = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run(generateObstacle), SKAction.run(updateScore), SKAction.run(checkWin)]))
        
        let actionCloudRepeat = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 7), SKAction.run(generateClouds)]))
        let actionCloud = SKAction.sequence([SKAction.wait(forDuration: 2),SKAction.run(generateClouds)])
        
        run(actionCloud){
            self.run(actionCloudRepeat)
            self.run(action)
        }
        
        kite = self.childNode(withName: "kite") as! SKSpriteNode
        
        kite.physicsBody?.collisionBitMask = PhysicsCategory.obstacles
        kite.physicsBody?.categoryBitMask = PhysicsCategory.kite
        kite.physicsBody?.contactTestBitMask = PhysicsCategory.obstacles
        kite.physicsBody?.restitution = 0.5
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
    }
    
    func generateClouds() {
        let posX = Int(arc4random_uniform(320))-180
        let size = CGSize(width: 300, height: 300)
        let actionMove = SKAction.move(to: CGPoint(x: posX, y: -1000), duration: TimeInterval(20))
        let actionMoveDone = SKAction.removeFromParent()
        let cloudsString = arrayClouds.randomElement()
        let clouds = SKSpriteNode(imageNamed: cloudsString)
        clouds.position = CGPoint(x: posX, y: 500)
        clouds.scale(to: size)
        addChild(clouds)
        clouds.run(SKAction.sequence([actionMove,actionMoveDone]))
    }
    
    func generateObstacle(){
        let posX = Int(arc4random_uniform(320))-180
        let size = CGSize(width: 60, height: 60)
        let obstacles = SKSpriteNode(imageNamed: "water")
        obstacles.scale(to: size)
        obstacles.position = CGPoint(x: posX, y: 420)
        obstacles.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        
        obstacles.physicsBody?.isDynamic = true
        obstacles.physicsBody?.collisionBitMask = PhysicsCategory.none
        obstacles.physicsBody?.categoryBitMask = PhysicsCategory.obstacles
        obstacles.physicsBody?.contactTestBitMask = PhysicsCategory.kite
        obstacles.physicsBody?.restitution = 0.5
        obstacles.physicsBody?.allowsRotation = true
        
        addChild(obstacles)
        
        switch second {
        case 0..<5:
            let time = Int(arc4random_uniform(4))+4
            let actionMove = SKAction.move(to: CGPoint(x: posX, y: -1000), duration: TimeInterval(time))
            let actionMoveDone = SKAction.removeFromParent()
            obstacles.run(SKAction.sequence([actionMove,actionMoveDone]))
        case 5..<10:
            let time = Int(arc4random_uniform(4))+3
            let actionMove = SKAction.move(to: CGPoint(x: posX, y: -1000), duration: TimeInterval(time))
            let actionMoveDone = SKAction.removeFromParent()
            obstacles.run(SKAction.sequence([actionMove,actionMoveDone]))
        case 10..<15:
            let time = Int(arc4random_uniform(4))+2
            let actionMove = SKAction.move(to: CGPoint(x: posX, y: -1000), duration: TimeInterval(time))
            let actionMoveDone = SKAction.removeFromParent()
            obstacles.run(SKAction.sequence([actionMove,actionMoveDone]))
        default:
            let time = Int(arc4random_uniform(4))+1
            let actionMove = SKAction.move(to: CGPoint(x: posX, y: -1000), duration: TimeInterval(time))
            let actionMoveDone = SKAction.removeFromParent()
            obstacles.run(SKAction.sequence([actionMove,actionMoveDone]))
        }
        
    }
    
    func updateScore(){
        second+=1
        print("\(second) s")
        scoreLabel.text = "\(second) s"
    }
    
    func checkWin(){
        if (second==10){
            removeAllActions()
            gameOver()
        }
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.collisionImpulse >= 0.8) && (contact.bodyA.categoryBitMask == PhysicsCategory.kite) && (contact.bodyB.categoryBitMask == PhysicsCategory.obstacles) {
            print("Hit!")
            isOver=true
            removeAllActions()
            gameOver()
        }
    }
    
    //Tap Recognizer
    func gameOver() {
        print("ended")
        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameOverLabel.position = CGPoint(x: 0, y: 0)
        gameOverLabel.fontColor = UIColor.white
        gameOverLabel.fontSize = 40
        gameOverLabel.alpha = 1
        addChild(gameOverLabel)
        
        let infoLabel = SKLabelNode(fontNamed: "Helvetica-Thin")
        infoLabel.position = CGPoint(x: 0, y: -35)
        infoLabel.fontSize = 25
        infoLabel.alpha = 1
        infoLabel.fontColor = UIColor.white
        infoLabel.text = "Tap to Restart 🚀"
        self.addChild(infoLabel)
        
        if !(isOver){
            gameOverLabel.text = "You Win! 😄"
            kite.physicsBody?.collisionBitMask = PhysicsCategory.none
            isOver = true
        }
        else{
            gameOverLabel.text = "You Lose 😢"
        }
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.5)
        run(SKAction.repeatForever(SKAction.sequence([fadeIn,SKAction.wait(forDuration: 0.2),fadeOut])))
        
    }
}
