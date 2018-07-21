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
import AVFoundation

//  Get random element from array
extension Array {
    func randomElement() -> Element  {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

//  Create kite node
let kiteTexture = SKTexture(imageNamed: "kite-1")
var kite = SKSpriteNode(texture: kiteTexture)

var second = 0
var isOver = true

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let kite: UInt32 = 0b1
    static let obstacles: UInt32 = 0b10
}

class GameScene: SKScene {
   
    let arrayClouds = ["clouds1","clouds3","clouds4","clouds5","clouds9","clouds7"]
    
    let motionManager = CMMotionManager()
  
    let tail = SKSpriteNode(color: UIColor.white, size: CGSize(width: 1, height: 400))
    
    var obstacles = SKSpriteNode()
    
    var progressBar = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        self.scene?.backgroundColor = #colorLiteral(red: 0.6161276698, green: 0.9302651286, blue: 1, alpha: 1)
      
        physicsWorld.contactDelegate = self
        
        second = 0
        isOver = false
//        progressBar = SKSpriteNode(color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), size: CGSize(width: 0, height: 20))
        
        addChild(progressBar)
        let moveKite = SKAction.moveTo(y: -175, duration: 3)
        
        let action = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run(generateObstacle), SKAction.run(updateScore), SKAction.run(checkWin),  SKAction.run(changeBG)]))
        
        let actionCloudRepeat = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 7), SKAction.run(generateClouds)]))
        let actionCloud = SKAction.sequence([SKAction.wait(forDuration: 2),SKAction.run(generateClouds)])
        
        run(actionCloud){
            self.run(actionCloudRepeat)
            self.run(action)
        }
        
        kite.scale(to: CGSize(width: 500, height: 500))
        kite.run(moveKite)
        addChild(kite)
        kite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 120))
        kite.physicsBody?.isDynamic = false
        kite.physicsBody?.collisionBitMask = PhysicsCategory.obstacles
        kite.physicsBody?.categoryBitMask = PhysicsCategory.kite
        kite.physicsBody?.contactTestBitMask = PhysicsCategory.obstacles
        kite.physicsBody?.affectedByGravity = false
        kite.physicsBody?.restitution = 0
        
        createTail()
      
    }
  
  func createTail() {
        let tailHolder = SKSpriteNode(color: UIColor.green, size: CGSize(width: 1, height: 1))
        tailHolder.position = CGPoint(x: 0, y: -500)
        tailHolder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        tailHolder.physicsBody?.isDynamic = true

        tail.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 400))
        tail.position = CGPoint(x: kite.position.x, y: kite.position.y - 200)
        tail.physicsBody?.isDynamic = true
        tail.color = UIColor.white
        tail.physicsBody?.collisionBitMask = PhysicsCategory.none
        tail.physicsBody?.contactTestBitMask = PhysicsCategory.none
        tail.zPosition = -1
    
        addChild(tail)
        addChild(tailHolder)
    
        let tailKiteJoint = SKPhysicsJointPin.joint(withBodyA: tail.physicsBody!, bodyB: kite.physicsBody! , anchor: CGPoint(x: kite.position.x, y: kite.position.y))
    
        let tailHolderJoint = SKPhysicsJointPin.joint(withBodyA: tailHolder.physicsBody!, bodyB: tail.physicsBody!, anchor: CGPoint(x: tailHolder.position.x, y: tailHolder.position.y))
    
        self.physicsWorld.add(tailKiteJoint)
        self.physicsWorld.add(tailHolderJoint)
    
        let rotationRange = SKRange(lowerLimit: -45.toRadian, upperLimit: 45.toRadian)
        let lockRotation = SKConstraint.zRotation(rotationRange)
        tail.constraints = [ lockRotation ]
      }
  
  func changeBG() {
//    let blue = #colorLiteral(red: 0.6161276698, green: 0.9302651286, blue: 1, alpha: 1)
        let orange = #colorLiteral(red: 1, green: 0.7476941943, blue: 0.2104941905, alpha: 1)
    
        let bgChange = SKAction.colorize(with: orange, colorBlendFactor: 1.0, duration: 15)
        run(bgChange)
      }
  
  //  Version 01 > More realistic & natural but still not moving
  
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
        obstacles = SKSpriteNode(imageNamed: "water")
        obstacles.scale(to: size)
        obstacles.position = CGPoint(x: posX, y: 420)
//        obstacles.physicsBody = SKPhysicsBody(circleOfRadius: 5.0)
        obstacles.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        
        obstacles.physicsBody?.isDynamic = true
        obstacles.physicsBody?.collisionBitMask = PhysicsCategory.kite
        obstacles.physicsBody?.categoryBitMask = PhysicsCategory.obstacles
        obstacles.physicsBody?.contactTestBitMask = PhysicsCategory.kite
        obstacles.physicsBody?.restitution = 1
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
        progressBar.removeFromParent()
        if (second<0){
            second = 0
        }
        print(second)
//        scoreLabel.text = "Energy: \(second)"
        progressBar = SKSpriteNode(color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), size: CGSize(width: Double(second)/10.0 * 375, height: 30))
        progressBar.position = CGPoint(x: -187.5, y: 350)
        addChild(progressBar)
    }
    
    func checkWin(){
        if (second==20){
//            progressBar = SKSpriteNode(color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), size: CGSize(width: 350, height: 20))
//            progressBar.position = CGPoint(x: -187.5, y: 350)
            removeAllActions()
            gameOver()
        }
        else if (second==0){
            isOver=true
            progressBar.removeFromParent()
            removeAllActions()
            gameOver()
        }
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.collisionImpulse >= 0.4) && (contact.bodyA.categoryBitMask == PhysicsCategory.kite) && (contact.bodyB.categoryBitMask == PhysicsCategory.obstacles) {
            print("Hit!")
            second-=2
            
            //Move kite after being hit
//            let moveObstacle = SKAction.move(to: CGPoint(x: 0, y: -175), duration: 1)
//            let moveKit = SKAction.moveTo(x: (self.view?.frame.size.width)!/2, duration: 1)
//            kite.physicsBody?.collisionBitMask = (obstacles.physicsBody?.categoryBitMask)!
//            obstacles.run(moveObstacle)
//            kite.run(moveKit)
//            obstacles.removeFromParent()
        }
    }
    
    func gameOver() {
        print("ended")
        
        if !(isOver){
            run(SKAction.playSoundFileNamed("winningSound.wav", waitForCompletion: false))
            let sun = SKSpriteNode(imageNamed: "sun")
            addChild(sun)
            
            sun.position = CGPoint(x: 0, y: 600)
            sun.size = CGSize(width: 300, height: 300)
            sun.run(SKAction.move(to: CGPoint(x: 0, y: 10), duration: 8))
            kite.physicsBody?.collisionBitMask = PhysicsCategory.none
            isOver = true
            
        }
        else{
            let flewAway = SKAction.move(to: CGPoint(x: 0, y: 600000), duration: 5000)
            kite.run(flewAway)
            removeAllActions()
            tail.removeFromParent()
            let loseSoundEffect = SKAction.playSoundFileNamed("losingSound.wav", waitForCompletion: false)
            run(loseSoundEffect)
        }
        
    }
}
