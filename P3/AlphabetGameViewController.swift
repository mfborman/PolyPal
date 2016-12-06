//
//  AlphabetGameViewController.swift
//  P3
//
//  Created by Tony Branson on 11/3/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//
import UIKit
import SpriteKit
class AlphabetGameViewController: UIViewController {
    
    
    @IBAction func backButton(_ sender: Any) {
        playMusic(filename: "Home_Screenn.mp3")
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    override func viewWillLayoutSubviews() {
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        let scene = AlphabetGameScene(size: skView.frame.size)
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        scene.viewController = self
        skView.presentScene(scene)
    }
    
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
