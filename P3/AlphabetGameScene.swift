//
//  AlphabetGameScene.swift
//  P3
//
//  Created by Tony Branson on 11/3/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//
import SpriteKit
import Foundation

class AlphabetGameScene: SKScene {
    
    let kLetterNodeName = "letter"
    let kQuizNodeName = "quiz"
    let kSpaceNodeName = "space"
    let background = SKSpriteNode(imageNamed: "alphabet_bgrnd")//background for game var
    var viewController: UIViewController?
    
    var selectedNode = SKSpriteNode()
    var letterImageNames: [String] = []
    var lettersOnScreen: [String]
    var correctlyPlacedLetters: [Letter]
    var missingLetters: [MissingLetter]
    var missingLetterCount = Int()
    var lettersCorrectlyPlaced = Int()
    var correctMatches: [String]
    var screenSize = CGSize()
    
    /*
     * Required super init
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * Initialize the graphics of the scene
     */
    override init(size: CGSize) {
        lettersOnScreen = []
        missingLetters = []
        correctlyPlacedLetters = []
        correctMatches = []
        
        super.init(size: size)//cover all paths
        
        //letters to be presented in a sequence on the chalkboard with blanks
        let letterImageNames = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        let letters = 26;//letters on board
        let quiz = 5//quiz letters
        var spaceCount = 0;//quiz spaces on board
        missingLetterCount = 5
        lettersCorrectlyPlaced = 0
        screenSize = self.frame.size
        
        self.background.name = "background"
        self.background.size = self.frame.size
        self.background.anchorPoint = CGPoint.zero
        self.background.zPosition = 0.0
        self.addChild(background)
        
        // Select random letters for the missing letter list
        repeat {
            let rand = Int(arc4random_uniform(UInt32(letters)))
            let letter = MissingLetter(letter: letterImageNames[rand])
            if !contains(letter: letter.letter, inArray: missingLetters) {
                missingLetters.append(letter)
            }
        } while missingLetters.count < missingLetterCount
        
        //generate the sprites on the chalkboard
        for i in 0..<letters {
            
            let sprite: SKSpriteNode
            let letter = letterImageNames[i]
            let spriteName: String
            
            if !contains(letter: letterImageNames[i], inArray: missingLetters){
                
                //generate sprite from letter images
                var imageName: String
                repeat {
                    imageName = letter
                } while lettersOnScreen.contains(imageName)
                lettersOnScreen.append(imageName)
                
                spriteName = kLetterNodeName + "." + imageName
                
            } else {
                
                //generate sprite from space images
                let imageName = "space"
                lettersOnScreen.append(imageName)
                
                spriteName = "space" + "." + letter
                spaceCount+=1;
                
            }
            // Create letter sprite
            sprite = Letter(spriteName: spriteName)
            
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
            
            //Finally add the sprite to the screen
            self.addChild(sprite)
            correctlyPlacedLetters.append(sprite as! Letter)

        }
        
        // Randomize array
        randomizeArray(&missingLetters)
        
        //Generates the quiz letter sprites on the screen
        for i in 0..<quiz {
            
            let sprite: SKSpriteNode
            let letter = missingLetters[i].letter
            
            let imageName = letter + "2"
            
            let spriteName = kQuizNodeName + "." + imageName
            sprite = Letter(spriteName: spriteName)

            // Resize sprite based on screen size
            let spriteSizeRatio = sprite.size.height/sprite.size.width
            var spriteSize: CGSize = screenSize
            spriteSize.height = screenSize.height * 0.1
            spriteSize.width = spriteSize.height * spriteSizeRatio
            sprite.size = spriteSize
            
            let xOffset = CGFloat(i+1) / (CGFloat(quiz)+1)
            let yOffset: CGFloat = 0.25
            
            //let push = size.width * CGFloat(1/letters)
            let x = (size.width * xOffset)
            sprite.position = CGPoint(x: x, y: size.height * yOffset)
            sprite.zPosition = 2.0
            
            //Finally add the sprite
            self.addChild(sprite)
            
            // Add quiz letter to complete list of letters
            for i in 0..<correctlyPlacedLetters.count {
                if (sprite as! Letter).letter == correctlyPlacedLetters[i].letter {
                    correctlyPlacedLetters[i] = sprite as! Letter
                }
            }
        }
        
    }
    
    func contains(letter: String, inArray: [MissingLetter]) -> Bool {
        for i in 0..<inArray.count {
            if inArray[i].letter == letter {
                return true
            }
        }
        return false
    }
    
    func getLetter(node: SKSpriteNode) -> String {
        let nodeName = node.name?.components(separatedBy: ".")
        return (nodeName?[1])!
    }
    
    func getType(node: SKSpriteNode) -> String {
        let nodeName = node.name?.components(separatedBy: ".")
        return (nodeName?[0])!
    }
    
    func letterPlacedCorrectly(letter: SKSpriteNode, location: SKSpriteNode) -> Bool {

        if getType(node: letter) == "quiz" && getType(node: location) == "space" {
            if getLetter(node: letter) == getLetter(node: location) {
                return true
            }
        }
        return false
    }
    
    func nodeIsQuizLetter(node: SKSpriteNode) -> Bool {
        let nodeName = node.name?.components(separatedBy: ".")
        let nodeType = nodeName?[0]
        if nodeType == kQuizNodeName {
            return true
        } else {
            return false
        }
    }
    
    func panForTranslation(_ translation: CGPoint) {
        let position = selectedNode.position
        
        if nodeIsQuizLetter(node: selectedNode) && !(selectedNode as! Letter).correctPlacement {
            
            selectedNode.run(SKAction.scale(to: 1.2, duration: 0.05))
            selectedNode.position = CGPoint(x: position.x+translation.x, y: position.y+translation.y)
        }
    }
    
    func selectNodeForTouch(_ touchLocation: CGPoint) {
        
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            selectedNode = touchedNode as! SKSpriteNode
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        
        selectNodeForTouch(positionInScene)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        panForTranslation(translation)
    }
    
    func turnLettersGold() -> SKAction {
        return SKAction.run {
            let increment = 0.04
            let totalTime = increment * Double(self.correctlyPlacedLetters.count)
            for i in 0..<self.correctlyPlacedLetters.count {
                let imageName = self.correctlyPlacedLetters[i].letter + "3"
                let delay = SKAction.wait(forDuration: increment * Double(i))
                let raise = SKAction.scale(to: 1.2, duration: 0.1)
                let turnGold = SKAction.setTexture(SKTexture(imageNamed: imageName))
                let fall = SKAction.scale(to: 1.0, duration: 0.1)
                let changeToGold = SKAction.sequence([delay, raise, turnGold, fall])
                self.correctlyPlacedLetters[i].run(changeToGold)
            }
        }
    }
    
    func dissipateLettersAndAddButtons() -> SKAction {
        return SKAction.run {
            let letterSize = self.correctlyPlacedLetters[0].size
            let animationTime = 1.0
            
            for i in 0..<self.correctlyPlacedLetters.count {
                //TODO: MAKING LETTERS MOVE AWAY AND FADE AFTER GAME VICTORY. WHILE THIS HAPPENS CHALKBOARD GETS REPLAY AND HOME BUTTONS 'WRITTEN' ON IT
                let positiveX = (Int(arc4random_uniform(UInt32(2))) == 1) ? true : false
                let positiveY = (Int(arc4random_uniform(UInt32(2))) == 1) ? true : false
                let offsetX = Int(arc4random_uniform(UInt32(letterSize.width)))
                let offsetY = Int(arc4random_uniform(UInt32(letterSize.height)))
                let xMovement: CGFloat = (positiveX) ? CGFloat(offsetX) : CGFloat(offsetX*(-1))
                let yMovement: CGFloat = (positiveY) ? CGFloat(offsetY) : CGFloat(offsetY*(-1))
                let currentPosition = self.correctlyPlacedLetters[i].position
                let destination = CGPoint(x: currentPosition.x+xMovement, y: currentPosition.y+yMovement)
                
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
                
                // Letter actions
                let moveAway = SKAction.move(to: destination, duration: animationTime)
                let fadeAway = SKAction.fadeOut(withDuration: animationTime)
                
                // Button actions
                let hide = SKAction.fadeOut(withDuration: 0.0)
                let wait = SKAction.wait(forDuration: animationTime/2)
                let fadeIn = SKAction.fadeIn(withDuration: animationTime)
                
                replayButton.run(SKAction.sequence([hide, wait, fadeIn]))
                homeButton.run(SKAction.sequence([hide, wait, fadeIn]))
                self.correctlyPlacedLetters[i].run(SKAction.group([moveAway, fadeAway]))
            }
        }
    }
    
    func handleEndGame() -> SKAction {
        return SKAction.run {
            // If the game has been won
            if self.lettersCorrectlyPlaced == self.missingLetterCount {
                
                //TODO: Find better solution to make dissipate happen after all letters are gold
                // Wait for letterAnimationTime multiplied by number of letters
                let waitForGoldLetters = SKAction.wait(forDuration:0.04*Double(self.correctlyPlacedLetters.count))
                let endGameAnimation = SKAction.sequence([self.turnLettersGold(), waitForGoldLetters, self.dissipateLettersAndAddButtons()])
                
                self.run(endGameAnimation)
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNodes = self.nodes(at: positionInScene)
        var letter = SKSpriteNode()
        var location = SKSpriteNode()
        let letterAnimationTime = 1.0//0.5
        let spaceAnimationTime = letterAnimationTime/2
        
        // If a letter is placed over another letter
        if touchedNodes.count > 1 {
            if touchedNodes[0] is SKSpriteNode && touchedNodes[1] is SKSpriteNode {
                letter = touchedNodes[0] as! SKSpriteNode
                location = touchedNodes[1] as! SKSpriteNode
                
                if letterPlacedCorrectly(letter: letter, location: location) {
                    
                    let properLocation = CGPoint(x: location.position.x, y: location.position.y)
                    
                    let aboveProperLocation = CGPoint(x: properLocation.x, y: properLocation.y+location.size.height/2)
                    
                    // Move letter above its space
                    let moveLetterAbove = SKAction.move(to: aboveProperLocation, duration: letterAnimationTime/5)
                    let dropLetter = SKAction.scale(to: 1.0, duration: letterAnimationTime/5)
                    let moveAboveProperLocation = SKAction.group([moveLetterAbove, dropLetter])
                    
                    // Pause letter
                    let dramaticPause = SKAction.wait(forDuration: letterAnimationTime/10)
                    
                    // Slam letter
                    let dipBelowProperLocation = SKAction.moveTo(y: properLocation.y-location.size.height/10, duration: letterAnimationTime/10)
                    let bounceAboveLocation = SKAction.moveTo(y: properLocation.y+location.size.height/20, duration: letterAnimationTime/8)
                    let moveToLocation = SKAction.move(to: properLocation, duration: letterAnimationTime/5)
                    let slam = SKAction.sequence([dipBelowProperLocation, bounceAboveLocation, moveToLocation])
                    
                    // Place letter properly
                    let fadeOutLetter = SKAction.fadeOut(withDuration: letterAnimationTime/5)
                    let fadeIn = SKAction.fadeIn(withDuration: letterAnimationTime/5)
                    let whitenLetter = SKAction.setTexture(SKTexture(imageNamed: getLetter(node: letter)))
                    
                    // Delay the space actions
                    let delayRemoval = SKAction.wait(forDuration: spaceAnimationTime*0.79)
                    
                    // Remove space
                    let fadeOutSpace = SKAction.fadeOut(withDuration: spaceAnimationTime/10)
                    let fallOut = SKAction.moveBy(x: 0.0, y: -location.size.height/3, duration: spaceAnimationTime/10)
                    let removeSpace = SKAction.group([fadeOutSpace, fallOut])
                    
                    // Entire letter animation
                    let changeLetterColor = SKAction.sequence([moveAboveProperLocation, dramaticPause, slam, fadeOutLetter, whitenLetter, fadeIn])
                    
                    // Entire space animation
                    let removeSpaceWithDelay = SKAction.sequence([delayRemoval, removeSpace])
                    
                    // Handle possible end of game scenario
                    let handleEndGame = self.handleEndGame()
                    
                    // Run Actions
                    letter.run(SKAction.sequence([changeLetterColor, handleEndGame]))
                    location.run(removeSpaceWithDelay)
                    
                    // Make updates for correct letter placement
                    (letter as! Letter).correctPlacement = true
                    lettersCorrectlyPlaced += 1
                    
                } else {
                    // Drop letter
                    letter.run(SKAction.scale(to: 1.0, duration: letterAnimationTime/5))
                }

            }
            
        }
        // Handle replay button touch when victory card is displayde
        if touchedNodes[0].name == "replayButton" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentVC = self.viewController
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SelectMatchingGameViewController")
            self.removeAllChildren()
            currentVC?.present(destinationVC, animated: true, completion: nil)
            
        } // Handle home button touch when victory card is displayed
        else if touchedNodes[0].name == "homeButton" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentVC = self.viewController
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
            self.removeAllChildren()
            currentVC?.present(destinationVC, animated: true, completion: nil)
            
        } // Handle card touches during game
        
    }
    
}
