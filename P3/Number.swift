//
//  Number.swift
//  P3
//
//  Created by Mitchell Borman on 12/5/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit
import SpriteKit

class Number: SKSpriteNode {

    var textureImage = SKTexture()
    
    init(spriteName: String) {
        
        textureImage = SKTexture(imageNamed: spriteName)
        
        super.init(texture: nil, color: .clear, size: textureImage.size())
        
        self.texture = textureImage
        self.name = spriteName
        self.zPosition = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
