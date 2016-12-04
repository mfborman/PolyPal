//
//  GameViewController.swift
//  P3
//
//  Created by Tony Branson on 10/27/16.
//  Copyright (c) 2016 Tony Branson. All rights reserved.
//

import UIKit
import SpriteKit

class MatchingGameViewController: UIViewController {
    
    var boardSize6by6 = Bool()
    
    override func viewWillLayoutSubviews() {
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        let scene = MatchingGameScene(size: skView.frame.size)
        scene.boardSize6by6 = boardSize6by6
        scene.settup()
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
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
