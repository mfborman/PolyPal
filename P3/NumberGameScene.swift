//
//  NumberGameScene.swift
//  P3
//
//  Created by Mitchell Borman on 12/5/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit
import SpriteKit

class NumberGameScene: SKScene {

    var viewController: UIViewController?
    let background = SKSpriteNode(imageNamed: "alphabet_bgrnd")//background for game var
    var selectedNode = SKSpriteNode()
    var screenSize = CGSize()

    /*
     * Required super init
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)//cover all paths
        
        screenSize = self.frame.size
        background.name = "background"
        background.size = self.frame.size
        background.anchorPoint = CGPoint.zero
        background.zPosition = 0.0
        addChild(background)

    }
}
