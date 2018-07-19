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
        label.frame = CGRect(x: 73, y: 288, width: 229, height: 90)
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
    
    @objc func startGame(){
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
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isOver=false
//        if (isOver){
//            let gameScene = GameScene(size: self.view.bounds.size)
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            self.view?.present(gameScene, transition:reveal)
//        }
//    }
}
