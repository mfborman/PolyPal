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
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    var digits: [String]
    var numbersToUse: [String]
    var spritesToUse: [SKSpriteNode]
    var numbers: [String]
    var numberOptions: [SKSpriteNode]
    var numberWordLabel = SKLabelNode()

    /*
     * Required super init
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        let labelFont = UIFont(name: "Noteworthy-bold", size: 50)
        digits = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero"]
        numbers = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen", "Twenty"]
        numbersToUse = []
        numberOptions = []
        spritesToUse = []
        
        super.init(size: size)//cover all paths
        
        screenSize = self.frame.size
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        background.name = "background"
        background.size = self.frame.size
        background.anchorPoint = CGPoint.zero
        background.zPosition = 0.0
        addChild(background)
        
        let numberOfChoices = 5
        let correctNumber: String

        // Select 5 random numbers to use
        repeat {
            let rand = Int(arc4random_uniform(UInt32(numberOfChoices)))
            if !numbersToUse.contains(numbers[rand]) {
                numbersToUse.append(numbers[rand])
            }
        } while numbersToUse.count < numberOfChoices
        
        // Select a the "winning" number
        correctNumber = numbersToUse[Int(arc4random_uniform(UInt32(numberOfChoices)))]
        
        // Display Number Name
        numberWordLabel.text = correctNumber
        numberWordLabel.fontName = labelFont?.fontName
        numberWordLabel.fontSize = 50
        numberWordLabel.position = CGPoint(x: screenWidth/2, y: screenHeight*(5/6))
        numberWordLabel.zPosition = 2.0
        background.addChild(numberWordLabel)
        
        for i in 0..<numbersToUse.count {
            //let number = SKSpriteNode
        }
    }
}
