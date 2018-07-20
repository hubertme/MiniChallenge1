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

class GameViewController: UIViewController  {
    
    let motionManager = CMMotionManager()
    let tapGesture = UITapGestureRecognizer()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        label.font = UIFont(name: "Helvetica", size: 40)
        label.frame = CGRect(x: 73, y: 351, width: 229, height: 90)
        label.textAlignment = NSTextAlignment(rawValue: 1)!
        label.text = "Tap to Start"
        label.alpha = 1
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(label)
        
        tapGesture.addTarget(self, action: #selector(startGame))
        self.view.addGestureRecognizer(tapGesture)
      
      
      
    }
    
//    override var shouldAutorotate: Bool {
//        return false
//    }
    
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        if UIDevice.current.userInterfaceIdiom == .phone {
    //            return .allButUpsideDown
    //        } else {
    //            return .all
    //        }
    //    }
    
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
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
//              print(kite.zRotation)
                let mult = 10.0
                if (kite.position.x + (25*1.41) + CGFloat(myData.acceleration.x * mult) <= (375/2)) && (kite.position.x - (25*1.41) + CGFloat(myData.acceleration.x * mult) >= (-375/2)){
                    kite.position.x += CGFloat((myData.acceleration.x) * mult)
                  
                  
                  
                    //  Limiting the rotation value of the kite
                    let rotationRange = SKRange(lowerLimit: -15.toRadian, upperLimit: 15.toRadian)
                    let lockRotation = SKConstraint.zRotation(rotationRange)
                    kite.constraints = [ lockRotation ]
                  
                    //  Move tail when kite moves
//                    tailPoints[0].x += CGFloat((myData.acceleration.x) * mult)
//                    tail.position.x += CGFloat((myData.acceleration.x) * mult)
                  
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
            kite.position=CGPoint(x: 0, y: -175)
            UIView.animate(withDuration: 1) {
                self.label.removeFromSuperview()
            }
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
