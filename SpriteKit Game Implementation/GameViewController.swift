//
//  GameViewController.swift
//  SpriteKit Game Implementation
//
//  Created by Hubert Wang on 18/07/18.
//  Copyright © 2018 Hubert Wang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation


class GameViewController: UIViewController  {
    
    var inGameBackground: AVAudioPlayer?

    
    let motionManager = CMMotionManager()
    let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "Tahoe.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            inGameBackground = try AVAudioPlayer(contentsOf: url)
            inGameBackground?.numberOfLoops = -1
            inGameBackground?.play()
        } catch{
            
        }
        
        //Commence and restart game
        startGame()
        tapGesture.addTarget(self, action: #selector(startGame))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        motionManager.accelerometerUpdateInterval = 0.02
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
//              print(kite.zRotation)
                let mult = 20.0
                if (kite.position.x + (25*1.41) + CGFloat(myData.acceleration.x * mult) <= (375/2)) && (kite.position.x - (25*1.41) + CGFloat(myData.acceleration.x * mult) >= (-375/2)){
                    
                    kite.position.x += CGFloat((myData.acceleration.x) * mult)
                  
                  
                  
                    //  Limiting the rotation value of the kite
                    let rotationRange = SKRange(lowerLimit: -15.toRadian, upperLimit: 15.toRadian)
                    let lockRotation = SKConstraint.zRotation(rotationRange)
                    kite.constraints = [ lockRotation ]
                  
                    //  Add rotation when the kite moves
                    kite.zRotation += (2 * -(myData.acceleration.x)).toRadian
                  
                }
                else if (kite.position.x < 0){
                    kite.position.x = (-375/2)+(25*1.41)
                }
                else{
                    kite.position.x = (375/2)-(25*1.41)
                }
            }
        }
    }
    
    @objc func startGame(){
        if (isOver){
            isOver=false
            kite.position=CGPoint(x: 0, y: -600)
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    
                    view.presentScene(scene)
                }
                view.ignoresSiblingOrder = true
            }
        }
    }
}

extension Double {
  var toRadian: CGFloat {
    return (CGFloat(self) * CGFloat.pi) / 180
  }
}
