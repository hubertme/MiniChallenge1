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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
            
        }
        
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }

//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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
                let mult = 10.0
                if (kite.position.x + (25*1.41) + CGFloat(myData.acceleration.x * mult) <= (375/2)) && (kite.position.x - (25*1.41) + CGFloat(myData.acceleration.x * mult) >= (-375/2)){
                    kite.position.x += CGFloat((myData.acceleration.x) * mult)
//                    print("ok")
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
    
}
