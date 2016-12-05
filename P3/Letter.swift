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
    
    let letterImage: SKTexture
    let fullLetterName: [String]
    var imageIdentifier: String
    var letter: String
    var correctPlacement: Bool
    
    init(spriteName: String) {
        
        fullLetterName = spriteName.components(separatedBy: ".")
        imageIdentifier = fullLetterName[1]
        let chars = imageIdentifier.characters.map { String($0) }
        letter = chars[0]
        
        let letterImageName = (fullLetterName[0]=="space") ? "space" : imageIdentifier
        
        letterImage = SKTexture(imageNamed: letterImageName)
        
        correctPlacement = (fullLetterName[0]=="quiz") ? false : true
        
        super.init(texture: nil, color: .clear, size: letterImage.size())
        
        self.texture = letterImage
        self.name = fullLetterName[0] + "." + ((chars.count > 1) ? chars[0] : fullLetterName[1])
        self.zPosition = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isCorrectlyPlaced() -> Bool {
        return correctPlacement
    }

}
