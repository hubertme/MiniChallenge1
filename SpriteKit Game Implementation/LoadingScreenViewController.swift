//
//  LoadingScreenViewController.swift
//  SpriteKit Game Implementation
//
//  Created by Alvin Julian on 19/07/18.
//  Copyright © 2018 Hubert Wang. All rights reserved.
//

import UIKit
import Lottie

class LoadingScreenViewController: UIViewController {

    private var emojiAnimation: LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        createLoadingAnimation()
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 2.0, execute: {
            print("Masuk")
            self.performSegue(withIdentifier:"mainGameSegue",sender: self)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createLoadingAnimation() {
        emojiAnimation = LOTAnimationView(name: "emojiJoy")
        emojiAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        emojiAnimation!.contentMode = .scaleAspectFit
        emojiAnimation!.frame = view.bounds
        emojiAnimation!.loopAnimation = true
        view.addSubview(emojiAnimation!)
        emojiAnimation!.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
