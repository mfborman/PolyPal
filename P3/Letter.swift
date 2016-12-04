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
    
    let image = SKTexture()
    let letterImage: SKTexture
    let letterName: [String]
    var correctPlacement: Bool
    
    init(spriteName: String) {
        
        letterName = spriteName.components(separatedBy: ".")
        let letterImageName = letterName[0]=="space" ? "space" : letterName[1]
        
        letterImage = SKTexture(imageNamed: letterImageName)
        
        correctPlacement = (letterName[0]=="quiz") ? false : true
        
        super.init(texture: nil, color: .clear, size: letterImage.size())
        
        self.texture = SKTexture(imageNamed: letterImageName)
        let chars = letterName[1].characters.map { String($0) }
        self.name = (chars.count > 1) ? chars[0] : letterName[1]
        self.zPosition = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isCorrectlyPlaced() -> Bool {
        return correctPlacement
    }

}
