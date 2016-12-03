//
//  Letter.swift
//  P3
//
//  Created by Mitchell Borman on 12/3/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit
import SpriteKit

class Letter: SKSpriteNode {
    
    let image: SKTexture
    let letterImageName: String
    let letterName: String
    
    init(letterName: String) {
        
        self.letterName = letterName.components(separatedBy: ".")
        letterImageName = letterName[1]

        // Resize sprite based on screen size
        let spriteSizeRatio = sprite.size.height/sprite.size.width
        var spriteSize: CGSize = screenSize
        spriteSize.height = screenSize.height * 0.1//changed from 0.2 to 0.09 because more letters
        spriteSize.width = spriteSize.height * spriteSizeRatio//this will shrink also
        sprite.size = spriteSize
        
        let xOffset : CGFloat
        let yOffset : CGFloat
        if i < 13 {
            yOffset = 0.8
            xOffset = CGFloat(i+1) / 14.0
            
        } else {
            yOffset = 0.65
            xOffset = CGFloat(i-12) / 14.0
        }
        let push = size.width * (1/14)
        let x = push + (size.width * (12/14) * xOffset)
        sprite.position = CGPoint(x: x, y: size.height * yOffset)
        sprite.zPosition = 2.0
        
        super.init(texture: nil, color: .clear, size: spriteSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
