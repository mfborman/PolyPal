//
//  GameScene.swift
//  P3
//
//  Created by Tony Branson on 10/27/16.
//  Copyright (c) 2016 Tony Branson. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation

private let kAnimalNodeName = "animal"

class AnimalGameScene: SKScene {
    let background = SKSpriteNode(imageNamed: "animals_bgrnd")
    //TODO: Remove global selectedNode logic. It disallows parallel node animations
    var selectedNode = SKSpriteNode()
    var targetAnimalLabel = SKLabelNode()
    var animalImageNames: [String] = []
    var animalsOnScreen: [String] = []
    //TODO: Maybe implement as key-value pair array to handle multiple dragged animals at once
    var animalStartingLocation = CGPoint()
    var audioPlayer: AVAudioPlayer!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        // Basic class setup
        self.animalImageNames = ["bear", "cow", "elephant", "giraffe", "goat", "hippo", "horse", "lion", "pig"]
        self.animalsOnScreen = []
        let screenSize = self.frame.size
        let onScreenAnimalCount = 4;

        // Create background
        self.background.name = "background"
        self.background.size = screenSize
        self.background.anchorPoint = CGPoint.zero
        self.addChild(background)
        self.background.zPosition = depth.background
        
        // Add Barn
        let barnSprite = SKSpriteNode(imageNamed: "barn")
        let barnX = screenSize.width * (0.75)
        let barnY = screenSize.height * (0.35)
        let spriteSizeRatio = barnSprite.size.height/barnSprite.size.width
        barnSprite.name = "barn"
        barnSprite.size.height = screenSize.height * (0.4)
        barnSprite.size.width = barnSprite.size.height * spriteSizeRatio
        barnSprite.position = CGPoint(x: barnX, y: barnY)
        barnSprite.zPosition = depth.barn
        self.background.addChild(barnSprite)

        // Add animal sprites
        for i in 0..<onScreenAnimalCount {
            var imageName: String
            repeat {
                imageName = animalImageNames[Int(arc4random_uniform(UInt32(animalImageNames.count)))]
            } while animalsOnScreen.contains(imageName)
            animalsOnScreen.append(imageName)
            
            let animalSprite = SKSpriteNode(imageNamed: imageName)
            // All animals are named in the format "animal.*animalType*" for example "animal.bear"
            animalSprite.name = kAnimalNodeName + "." + imageName
            
            // Resize sprite based on screen size
            let spriteSizeRatio = animalSprite.size.height/animalSprite.size.width
            var spriteSize: CGSize = screenSize
            spriteSize.height = screenSize.height * 0.2
            spriteSize.width = spriteSize.height * spriteSizeRatio
            animalSprite.size = spriteSize
            
            // Set animal position
            let xOffset = (i%2 > 0) ? CGFloat(0.4) : CGFloat(0.75)
            let yOffset = CGFloat(CGFloat(i+2)/CGFloat(onScreenAnimalCount+3))
            animalSprite.position = CGPoint(x: size.width/2 * xOffset, y: size.height * yOffset)
            animalSprite.zPosition = depth.animal
            self.addChild(animalSprite)
            
            // Set up actions
            let delay = SKAction.wait(forDuration: 0.2)
            let minimize = SKAction.scale(to: 0.0, duration: 0.0)
            let grow = SKAction.scale(to: 1.2, duration: 0.4)
            let shrink = SKAction.scale(to: 1.0, duration: 0.2)
            let playSound = playNextAnimalSound()

            // Execute actions
            let spawnAction = SKAction.sequence([minimize, delay, grow, shrink, playSound])
            animalSprite.run(spawnAction)
        }

        // Add name label for target animal
        self.targetAnimalLabel = SKLabelNode(fontNamed: "Noteworthy-bold")
        self.targetAnimalLabel.position = CGPoint(x: barnX, y: barnY+barnSprite.size.height*(3/5))
        self.targetAnimalLabel.text = animalsOnScreen[0]
        self.targetAnimalLabel.fontSize = 50
        self.targetAnimalLabel.zPosition = depth.label
        self.background.addChild(self.targetAnimalLabel)

    }
    
    /*
     * Plays current animal sound, or victory sound if game complete
     * Additionally updates animal name label
     *
     * Params: 
     * Returns: SKAction
     */
    func playNextAnimalSound() -> SKAction {
        return SKAction.run {
            
            let soundFileName: String
            if self.animalsOnScreen.count > 0 {
                let currentAnimal = self.animalsOnScreen[0]
                self.targetAnimalLabel.text = currentAnimal
                soundFileName = currentAnimal
            } else {
                self.targetAnimalLabel.text = "Great Job!"
                soundFileName = "animalVictorySound"
            }
            //TODO: Use SpriteKit Audio
            let audioFilePath = Bundle.main.path(forResource: soundFileName, ofType: "mp3")!
            do {
                let url = URL(fileURLWithPath: audioFilePath)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            } catch {
            }
        }
    }
    
    /*
     * Automatically called when a touch event begins
     * Calls selectNodeForTouch on the location of the touch event
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        
        selectNodeForTouch(positionInScene)
        
    }
    
    /*
     * Automatically called when a touch event ends
     * Checks if an animal node was being dragged. Calls appropriate method based
     *    on if correct animal was dragged and if animal was placed over barn
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        
        let touchedNodes = self.nodes(at: positionInScene)
        if nodeIsAnAnimal(node: touchedNodes[0] as! SKSpriteNode) {
            if touchedNodes[1].name == "barn" &&
                getAnimalType(animal: touchedNodes[0] as! SKSpriteNode) == animalsOnScreen[0] {
                
                correctAnimalPlacement(animal: touchedNodes[0] as! SKSpriteNode, barn: touchedNodes[1] as! SKSpriteNode)
                
            } else if touchedNodes[0].position.x > self.frame.size.width/2 {
                
                let previousTouchLocation = touch.previousLocation(in: self)
                incorrectAnimalPlacement(animal: touchedNodes[0] as! SKSpriteNode, previousLocation: previousTouchLocation)
                
            } else {
                
                animalStartingLocation = touchedNodes[0].position
                touchedNodes[0].run(returnToInitialState(sprite: touchedNodes[0] as! SKSpriteNode))
                
            }
        }
    }
    
    /*
     * Animates animal moving from current location to barn door location, then removes it from scene
     *
     * Params: SKSpriteNode, SKSPriteNode
     */
    func correctAnimalPlacement(animal: SKSpriteNode, barn: SKSpriteNode) {
        
        let animationTime = 0.8
        
        // Move animal to barn door
        let barnLocation = barn.position
        let barnHeight = barn.size.height
        let barnWidth = barn.size.width
        let barnDoorLocation = CGPoint(x: barnLocation.x-(barnWidth/50), y: barnLocation.y-(barnHeight/3.5))
        let animalLocation = animal.position
        
        //FIXME: Animals stick and pile up if dragged consecutively to quickly
        let path = CGMutablePath()
        path.move(to: CGPoint(x: animalLocation.x, y: animalLocation.y))
        path.addLine(to: CGPoint(x: barnDoorLocation.x, y: barnDoorLocation.y))
        let followLine = SKAction.follow(path, asOffset: false, orientToPath: false, duration: animationTime/2)
        
        // Pop animal
        let pop = SKAction.scale(to: 1.2, duration: animationTime/4)

        // Shrink the animal away
        let shrink = SKAction.scale(to: 0, duration: animationTime)
        
        // Remove Animal from scene
        let removeNode = SKAction.removeFromParent()
        animalsOnScreen.remove(at: 0)
        
        // Execute animations
        let popShrinkSequence = SKAction.sequence([pop, shrink])
        let moveGroup = SKAction.group([popShrinkSequence, followLine])
        let playSound = playNextAnimalSound()
        let finalSequence = SKAction.sequence([moveGroup, removeNode, playSound])
        selectedNode.run(finalSequence)
        
    }
    
    /*
     * Animates animal moving from current location to location at beginning of drag
     *
     * Params: SKSpriteNode, CGPoint
     */
    func incorrectAnimalPlacement(animal: SKSpriteNode, previousLocation: CGPoint) {
        
        let animationTime = 0.7
        
        // Move animal back to starting location
        let animalLocation = animal.position
        let path = CGMutablePath()
        path.move(to: CGPoint(x: animalLocation.x, y: animalLocation.y))
        path.addLine(to: CGPoint(x: animalStartingLocation.x, y: animalStartingLocation.y))
        let followLine = SKAction.follow(path, asOffset: false, orientToPath: false, duration: animationTime)
        
        // Flip animal 360 degrees
        let flip = SKAction.rotate(byAngle: degToRad(360), duration: animationTime)
        
        // Replay animal sound
        let playSound = playNextAnimalSound()
        
        // Execute animations
        let returnAnimal = SKAction.group([followLine, flip])
        let finalSequence = SKAction.sequence([returnAnimal, returnToInitialState(sprite: selectedNode), playSound])
        selectedNode.run(finalSequence)
    }
    
    /*
     * Builds custom SKAction to return sprite to original rotation
     *
     * Params: SKSPriteNode
     * Returns: SKAction
     */
    func returnToInitialState(sprite: SKSpriteNode)->SKAction {
        return SKAction.run {
            sprite.removeAction(forKey: "shake")
            let rotate = SKAction.rotate(toAngle: 0.0, duration: 0.1)
            let resize = SKAction.scale(to: 1.0, duration: 0.0)
            sprite.run(SKAction.group([rotate, resize]))
        }
    }


    
    /*
     * Checks to see if a node is an animal node
     * 
     * Params: SKSpriteNode
     * Returns: Bool
     */
    func nodeIsAnAnimal(node: SKSpriteNode) -> Bool {
        let nodeName = node.name?.components(separatedBy: ".")
        if nodeName?[0] == "animal" {
            return true
        } else {
            return false
        }
    }
    
    /*
     * Provides the type of animal of the given node
     *
     * Params: SKSpriteNode
     * Returns: String
     *                 "" if node is not an animal
     *                 animalType if node is an animal
     */
    func getAnimalType(animal: SKSpriteNode) -> String {
        if !nodeIsAnAnimal(node: animal) {
            return ""
        } else {
            let fullAnimalName = animal.name?.components(separatedBy: ".")
            let animalType = fullAnimalName?[1]
            return animalType!
        }
    }
    
    /*
     * Helper method for shake animation which converts degrees to radians
     */
    func degToRad(_ degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    /*
     *
     */
    func selectNodeForTouch(_ touchLocation: CGPoint) {
        
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            //if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                // If an animal is being dragged begin to shake it
                if nodeIsAnAnimal(node: touchedNode as! SKSpriteNode) {
                    animalStartingLocation = touchedNode.position
                    let sequence = SKAction.sequence([
                        SKAction.scale(to: 1.1, duration: 0.0),
                        SKAction.rotate(byAngle: degToRad(-4.0), duration: 0.1),
                        SKAction.rotate(byAngle: 0.0, duration: 0.1),
                        SKAction.rotate(byAngle: degToRad(4.0), duration: 0.1)])
                    selectedNode.run(SKAction.repeatForever(sequence), withKey: "shake")
                }
            //}
        }
    }
    
    func boundLayerPos(_ aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    func panForTranslation(_ translation: CGPoint) {
        let position = selectedNode.position
        
        if nodeIsAnAnimal(node: selectedNode) {
            selectedNode.position = CGPoint(x: position.x+translation.x, y: position.y+translation.y)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        panForTranslation(translation)
    }
    
    
}


