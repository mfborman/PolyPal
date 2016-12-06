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
    var correctNumber = String()
    let labelFont = UIFont(name: "Noteworthy-bold", size: 200)
    
    let correctNumberAnimationConstant = 0.5

    /*
     * Required super init
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        digits = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero"]
        numbers = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen", "Twenty"]
        numbersToUse = []
        spritesToUse = []
        numberOptions = []
        
        super.init(size: size)//cover all paths
        
        screenSize = self.frame.size
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        background.name = "background"
        background.size = self.frame.size
        background.anchorPoint = CGPoint.zero
        background.zPosition = cardPriority.background
        addChild(background)
        
        self.run(generateGameScreen())
        
    }
    
    func generateGameScreen() -> SKAction {
        return SKAction.run {
            let numberOfChoices = 5
            
            self.numbersToUse = []
            self.spritesToUse = []
            self.numberWordLabel = SKLabelNode()
            
            // Select 5 random numbers to use
            repeat {
                let rand = Int(arc4random_uniform(UInt32(self.numbers.count)))
                if !self.numbersToUse.contains(self.numbers[rand]) {
                    self.numbersToUse.append(self.numbers[rand])
                }
            } while self.numbersToUse.count < numberOfChoices
            
            // Select a the "winning" number
            self.correctNumber = self.numbersToUse[Int(arc4random_uniform(UInt32(numberOfChoices)))]
            print(self.correctNumber)
            print(self.numbersToUse.count)
            for i in 0..<self.numbersToUse.count {
                let number = Number(spriteName: self.numbersToUse[i])
                number.position.x = self.screenWidth/6 * CGFloat(i+1)
                number.position.y = (i%2==0) ? self.screenHeight*(7/24) : self.screenHeight/6
                number.zPosition = cardPriority.standard
                number.name = self.numbersToUse[i]
                self.spritesToUse.append(number)
                
                // Animate number onto screen with pop-bounce
                self.background.addChild(number)
                let enterScene = self.popUpBounce(node: self.spritesToUse[self.spritesToUse.count-1])
                self.spritesToUse[self.spritesToUse.count-1].run(enterScene)
            }
            
            // Display Number Name
            self.numberWordLabel.text = self.correctNumber
            self.numberWordLabel.fontName = self.labelFont?.fontName
            self.numberWordLabel.fontSize = (self.labelFont?.pointSize)!
            self.numberWordLabel.position = CGPoint(x: self.screenWidth/2, y: self.screenHeight*(3/5))
            self.numberWordLabel.zPosition = cardPriority.standard
            
            // Animate number onto screen with pop-bounce
            
            self.background.addChild(self.numberWordLabel)
        }
    }
    
    func popUpBounce(node: SKSpriteNode) -> SKAction {
        return SKAction.run {
            let hide = SKAction.scale(to: 0.0, duration: 0.0)
            let pop = SKAction.scale(to: 1.3, duration: self.correctNumberAnimationConstant/3)
            let settle = SKAction.scale(to: 1.0, duration: self.correctNumberAnimationConstant/3)
            node.run(SKAction.sequence([hide, pop, settle]))
        }
    }
    
    func moveLabel() -> SKAction {
        return SKAction.run {
            let moveLabelLeft = SKAction.moveTo(x: self.screenWidth/3, duration: self.correctNumberAnimationConstant)
            let resize = SKAction.scale(to: 0.7, duration: self.correctNumberAnimationConstant)
            let fadeOut = SKAction.fadeOut(withDuration: self.correctNumberAnimationConstant)
            let blowUp = SKAction.scale(to: 2.0, duration: self.correctNumberAnimationConstant)

            let moveAndResize = SKAction.group([moveLabelLeft, resize])
            let remove = SKAction.group([fadeOut, blowUp])
            let moveAndRemove = SKAction.sequence([moveAndResize, remove])
            self.numberWordLabel.run(moveAndRemove)
        }
    }
    
    func moveCorrectLetter() -> SKAction {
        return SKAction.run {
            let dest = CGPoint(x: self.screenWidth*(3/4), y: self.screenHeight*(7/10))
            let moveToChalkboard = SKAction.move(to: dest, duration: self.correctNumberAnimationConstant)
            var index = 0
            while self.spritesToUse[index].name != self.correctNumber {
                index += 1
            }
            let blowUp = SKAction.scale(to: 3.0, duration: self.correctNumberAnimationConstant)
            let fadeOut = SKAction.fadeOut(withDuration: self.correctNumberAnimationConstant)
            
            let remove = SKAction.group([fadeOut, blowUp])
            let moveAndRemove = SKAction.sequence([moveToChalkboard, remove])
            self.spritesToUse[index].run(moveAndRemove)
        }
    }
    
    func removeBackgroundChildren() -> SKAction {
        return SKAction.run {
            self.background.removeAllChildren()
        }
    }
    
    func handleCorrectAnswer() -> SKAction {
        return SKAction.run {
            // Move wordName to left, pop and fade
            let handleWord = self.moveLabel()
            
            // Move correct number onto chalkboard, pop and fade
            let handleCorrectNumber = self.moveCorrectLetter()

            // Handle Chalkboard removal
            let clearOldInfo = SKAction.group([handleWord, handleCorrectNumber])
            self.run(SKAction.sequence([clearOldInfo, self.removeBackgroundChildren(), self.generateGameScreen()]))
            
            // Pop numbers into new numbers
            
            // Pop up wordName
        }
    }
    
    func selectNodeForTouch(_ touchLocation: CGPoint) {
        
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            selectedNode = touchedNode as! SKSpriteNode
            if selectedNode is Number {
                selectedNode.run(SKAction.scale(to: 1.2, duration: 0.05))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        
        selectNodeForTouch(positionInScene)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNodes = self.nodes(at: positionInScene)
        
        if touchedNodes[0] is SKSpriteNode {
            selectedNode = touchedNodes[0] as! SKSpriteNode
            if selectedNode is Number {
                if selectedNode.name == correctNumber {
                    self.run(handleCorrectAnswer())
                } else {
                    selectedNode.run(SKAction.scale(to: 1.0, duration: 0.05))
                }
            }
        }
    }
}
