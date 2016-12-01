//
//  AlphabetGameScene.swift
//  P3
//
//  Created by Tony Branson on 11/3/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//
import SpriteKit
class AlphabetGameScene: SKScene {
    
    let kLetterNodeName = "letter"
    let kQuizNodeName = "quiz"
    let kSpaceNodeName = "space"
    
    let background = SKSpriteNode(imageNamed: "alphabet_bgrnd")//background for game var
    var selectedNode = SKSpriteNode()
    var letterImageNames: [String] = []
    var lettersOnScreen: [String]
    var missingLetters: [MissingLetter]
    var correctMatches: [String]
    
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
        self.lettersOnScreen = []
        self.missingLetters = []
        correctMatches = []
        
        super.init(size: size)//cover all paths
        
        //letters to be presented in a sequence on the chalkboard with blanks
        let letterImageNames = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        let letters = 26;//letters on board
        let quiz = 5//quiz letters
        var spaceCount = 0;//quiz spaces on board
        let missingLetterCount = 5
        let screenSize = self.frame.size
        
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
            
            if !contains(letter: letterImageNames[i], inArray: missingLetters){
                
                //generate sprite from letter images
                var imageName: String
                repeat {
                    imageName = letter
                } while lettersOnScreen.contains(imageName)
                lettersOnScreen.append(imageName)
                
                sprite = SKSpriteNode(imageNamed: imageName)
                sprite.name = kLetterNodeName + "." + imageName
                
            } else {
                
                //generate sprite from space images
                let imageName = "space"
                lettersOnScreen.append(imageName)
                
                sprite = SKSpriteNode(imageNamed: imageName)
                sprite.name = "space" + "." + letter
                spaceCount+=1;
                
            }
            
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
            
        }
        
        // Randomize array
        randomizeArray(&missingLetters)
        
        //Generates the shape sprites on the screen
        for i in 0..<quiz {
            
            let sprite: SKSpriteNode
            let letter = missingLetters[i].letter
            
            let imageName = letter + "2"
            
            sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = kQuizNodeName + "." + letter

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
            
            //Finally add the sprite t
            self.addChild(sprite)
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
        if nodeName?[0] == kQuizNodeName {
            return true
        } else {
            return false
        }
    }
    
    func animateForCorrectPlacement(letter: SKSpriteNode) -> SKAction {
        return SKAction.run {
            let wiggle = SKAction.rotate(byAngle: 0.2, duration: 1)
            letter.run(wiggle)
        }
    }
    
    func panForTranslation(_ translation: CGPoint) {
        let position = selectedNode.position
        
        if nodeIsQuizLetter(node: selectedNode) {
            selectedNode.position = CGPoint(x: position.x+translation.x, y: position.y+translation.y)
        }
    }
    
    func selectNodeForTouch(_ touchLocation: CGPoint) {
        
        let touchedNode = self.atPoint(touchLocation)
        if touchedNode is SKSpriteNode {
            
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                selectedNode = touchedNode as! SKSpriteNode
            }
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNodes = self.nodes(at: positionInScene)
        var letter = SKSpriteNode()
        var location = SKSpriteNode()
        
        if (touchedNodes[0] is SKSpriteNode && touchedNodes[1] is SKSpriteNode) {
            letter = touchedNodes[0] as! SKSpriteNode
            location = touchedNodes[1] as! SKSpriteNode
        }
        
        
        if letterPlacedCorrectly(letter: letter, location: location) {
            print(getLetter(node: letter) + " " + getLetter(node: location))
            let letterAnimationTime = 1.0//0.5
            let spaceAnimationTime = letterAnimationTime/2
            
            
            let properLocation = CGPoint(x: location.position.x, y: location.position.y)
        
            let aboveProperLocation = CGPoint(x: properLocation.x, y: properLocation.y+location.size.height/2)
            
            // Letter actions
            let moveAboveProperLocation = SKAction.move(to: aboveProperLocation, duration: letterAnimationTime/5)
            
            let dramaticPause = SKAction.wait(forDuration: letterAnimationTime/10)
            
            let dipBelowProperLocation = SKAction.moveTo(y: properLocation.y-location.size.height/10, duration: letterAnimationTime/10)
            let moveToLocation = SKAction.move(to: properLocation, duration: letterAnimationTime/10)
            let slam = SKAction.sequence([dipBelowProperLocation, moveToLocation])
            
            let fadeOutLetter = SKAction.fadeOut(withDuration: letterAnimationTime/5)
            
            let fadeIn = SKAction.fadeIn(withDuration: letterAnimationTime/5)
            
            let whitenLetter = SKAction.setTexture(SKTexture(imageNamed: getLetter(node: letter)))
            
            // Space actions
            let delayRemoval = SKAction.wait(forDuration: spaceAnimationTime)
            
            let fadeOutSpace = SKAction.fadeOut(withDuration: spaceAnimationTime/20)
            let fallOut = SKAction.moveBy(x: 0.0, y: -location.size.height/3, duration: spaceAnimationTime/20)
            let removeSpace = SKAction.group([fadeOutSpace, fallOut])
            
            // Complete letter animation
            let changeLetterColor = SKAction.sequence([moveAboveProperLocation, dramaticPause, slam, fadeOutLetter, whitenLetter, fadeIn])
            
            // Complete space animation
            let removeSpaceWithDelay = SKAction.sequence([delayRemoval, removeSpace])
            
            // Run Actions
            letter.run(changeLetterColor)
            location.run(removeSpaceWithDelay)
        }
        
    }
    
}
