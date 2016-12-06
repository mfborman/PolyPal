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
    var stars: [SKSpriteNode]
    var starsToWin = Int()
    var currentStars = Int()
    var numberWordLabel = SKLabelNode()
    var correctNumber = String()
    var labelFontSize: CGFloat = 150
    let labelFont: UIFont
    
    let correctNumberAnimationConstant = 0.5

    /*
     * Required super init
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        labelFont = UIFont(name: "Noteworthy-bold", size: labelFontSize)!
        digits = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero"]
        numbers = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen", "Twenty"]
        numbersToUse = []
        spritesToUse = []
        numberOptions = []
        stars = []
        
        super.init(size: size)//cover all paths
        
        screenSize = self.frame.size
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        starsToWin = 10
        currentStars = 0

        background.name = "background"
        background.size = self.frame.size
        background.anchorPoint = CGPoint.zero
        background.zPosition = cardPriority.background
        addChild(background)
        
        // Add stars to chalkboard
        for i in 0..<starsToWin {
            let star = SKSpriteNode(imageNamed: "gray_star")
            star.position.y = screenHeight*(20/21)
            star.position.x = (screenWidth/11)*CGFloat(i+1)
            star.size.height = screenHeight/30
            star.size.width = star.size.height
            star.zPosition = cardPriority.moving
            star.name = "star"
            stars.append(star)
            self.background.addChild(star)
        }
        
        // Play Music
        playMusic(filename: "Alphabet_Gamee.mp3")
        
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
            self.numberWordLabel.fontName = self.labelFont.fontName
            self.numberWordLabel.fontSize = self.labelFontSize
            self.numberWordLabel.position = CGPoint(x: self.screenWidth/2, y: self.screenHeight*(3/5))
            self.numberWordLabel.zPosition = cardPriority.standard
            
            // Animate word onto screen with pop-bounce
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
            let moveLabelLeft = SKAction.moveTo(y: self.screenHeight*(7/10), duration: self.correctNumberAnimationConstant)
            let resize = SKAction.scale(to: 0.7, duration: self.correctNumberAnimationConstant)
            let fadeOut = SKAction.fadeOut(withDuration: self.correctNumberAnimationConstant)
            let blowUp = SKAction.scale(to: 2.0, duration: self.correctNumberAnimationConstant)

            let moveAndResize = SKAction.group([moveLabelLeft, resize])
            let remove = SKAction.group([fadeOut, blowUp])
            let pause = SKAction.wait(forDuration: 0.2)
            let moveAndRemove = SKAction.sequence([moveAndResize, pause, remove])
            self.numberWordLabel.run(moveAndRemove)
        }
    }
    
    func moveCorrectLetter() -> SKAction {
        return SKAction.run {
            let dest = CGPoint(x: self.screenWidth/2, y: self.screenHeight*(6/10))
            let moveToChalkboard = SKAction.move(to: dest, duration: self.correctNumberAnimationConstant)
            var index = 0
            while self.spritesToUse[index].name != self.correctNumber {
                index += 1
            }
            let shrink = SKAction.scale(to: 0.01, duration: self.correctNumberAnimationConstant*(2/3))
            let hitStar = SKAction.move(to: self.stars[self.currentStars].position, duration: self.correctNumberAnimationConstant*(2/3))
            
            let remove = SKAction.group([hitStar, shrink])
            let pause = SKAction.wait(forDuration: 0.2)
            let moveAndRemove = SKAction.sequence([moveToChalkboard, pause, remove])
            self.spritesToUse[index].run(moveAndRemove)
        }
    }
    
    func animateObtainedStar() -> SKAction {
        return SKAction.run {
            let spin = SKAction.rotate(byAngle: degToRad(360.0), duration: 0.4)
            let pop = SKAction.scale(to: 1.2, duration: 0.2)
            let rise = SKAction.moveTo(y: self.stars[self.currentStars].position.y+self.stars[self.currentStars].size.height*(2/3), duration: 0.2)
            let turnGold = SKAction.setTexture(SKTexture(imageNamed: "gold_star"))
            let sink = SKAction.scale(to: 1.0, duration: 0.2)
            let fall = SKAction.moveTo(y: self.stars[self.currentStars].position.y, duration: 0.2)
            
            let up = SKAction.group([pop, rise])
            let down = SKAction.group([sink, fall])
            let moveStar = SKAction.sequence([up, turnGold, down])
            let finalAnimation = SKAction.group([spin, moveStar])
            self.stars[self.currentStars].run(finalAnimation)
            self.currentStars += 1
            if self.currentStars == 10 {
                
                // Create replay button
                let replayButton = SKSpriteNode(imageNamed: "white_replay_btn")
                replayButton.size = CGSize(width: self.screenSize.width/5, height: self.screenSize.width/5)
                replayButton.zPosition = 2
                replayButton.position.x = self.screenSize.width*(1/3)
                replayButton.position.y = self.screenSize.height*(7/10)
                replayButton.name = "replayButton"
                self.addChild(replayButton)
                
                // Create home button
                let homeButton = SKSpriteNode(imageNamed: "white_home_btn")
                homeButton.size = CGSize(width: self.screenSize.width/5, height: self.screenSize.width/5)
                homeButton.zPosition = 2
                homeButton.color = SKColor.blue
                homeButton.position.x = self.screenSize.width*(2/3)
                homeButton.position.y = self.screenSize.height*(7/10)
                homeButton.name = "homeButton"
                self.addChild(homeButton)
            }
        }
    }
    
    func removeBackgroundChildren() -> SKAction {
        return SKAction.run {
            self.background.children.filter { $0.name != "star" }.forEach { $0.removeFromParent() }
        }
    }
    
    func handleCorrectAnswer() -> SKAction {
        return SKAction.run {
            // Move wordName to left, pop and fade
            let handleWord = self.moveLabel()
            
            // Move correct number onto chalkboard, pop and fade
            let handleCorrectNumber = self.moveCorrectLetter()

            // Hit star
            let hitStar = SKAction.sequence([handleCorrectNumber, SKAction.wait(forDuration: self.correctNumberAnimationConstant*2), self.animateObtainedStar()])
            
            // Handle Chalkboard removal
            let clearOldInfo = SKAction.group([handleWord, hitStar])
            
            // Reset chalkboard and add new numbers
            print(self.currentStars)
            if self.currentStars >= 9 {
                self.run(SKAction.sequence([clearOldInfo, SKAction.wait(forDuration: 0.3) , self.removeBackgroundChildren()]))
            } else {
                self.run(SKAction.sequence([clearOldInfo, SKAction.wait(forDuration: 0.3) , self.removeBackgroundChildren(), self.generateGameScreen()]))
            }
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
        // Handle replay button touch when victory card is displayde
        if touchedNodes[0].name == "replayButton" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentVC = self.viewController
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SelectAlphabetGameViewController")
            self.removeAllChildren()
            currentVC?.present(destinationVC, animated: true, completion: nil)
            
        } // Handle home button touch when victory card is displayed
        else if touchedNodes[0].name == "homeButton" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //let currentVC = self.viewController
            //let destinationVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
            self.removeAllChildren()
            //currentVC?.present(destinationVC, animated: true, completion: nil)
            self.view?.window!.rootViewController?.dismiss(animated: false, completion: nil)//FIXME: removes all but root, should remove all before home
            
        } // Handle card touches during game
    }
}
