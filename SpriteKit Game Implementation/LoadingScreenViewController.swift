//
//  LoadingScreenViewController.swift
//  SpriteKit Game Implementation
//
//  Created by Alvin Julian on 19/07/18.
//  Copyright © 2018 Hubert Wang. All rights reserved.
//

import AVFoundation
import UIKit
import Lottie

class LoadingScreenViewController: UIViewController {

    private var emojiAnimation: LOTAnimationView?
    var sayCheeseSoundEffect: AVAudioPlayer?
    
    @IBOutlet weak var kiteLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLoadingAnimation()
        
        let maxWidth = view.frame.maxX
        let maxHeight = view.frame.maxY
        
        kiteLogo.transform = CGAffineTransform(scaleX: -1, y: 1)
        kiteLogo.frame = CGRect(x: maxWidth/2 - 100, y: maxHeight/2 - 150, width: 300, height: 300)
        
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
        let maxWidth = view.frame.maxX
        let maxHeight = view.frame.maxY
        
        emojiAnimation = LOTAnimationView(name: "emojiJoy")
        emojiAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        emojiAnimation!.contentMode = .scaleAspectFit
        emojiAnimation!.frame = view.bounds
        emojiAnimation!.frame = CGRect(x: maxWidth/2 - 100, y: maxHeight - 200, width: 200, height: 200)
        emojiAnimation!.loopAnimation = true
        view.addSubview(emojiAnimation!)
        emojiAnimation!.play()
        
        let path = Bundle.main.path(forResource: "saycheese.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            sayCheeseSoundEffect = try AVAudioPlayer(contentsOf: url)
            sayCheeseSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
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
