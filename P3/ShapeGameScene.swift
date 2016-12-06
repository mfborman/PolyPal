//
// GameScene.swift
// P3
//
// Created by Tony Branson on 10/27/16.
// Copyright (c) 2016 Tony Branson. All rights reserved.
//

import SpriteKit
import AVFoundation

private let kShapeNodeName = "shape"
private let kHoleNodeName = "hole"


class ShapeGameScene: SKScene {
    let background = SKSpriteNode(imageNamed: "shapes_bgrnd")
    var selectedNode = SKSpriteNode()
    var shapeImageNames: [String] = []//shape array
    var holeImageNames: [String] = []//hole array
    var shapesOnScreen: [String] = []
    var holesOnScreen: [String] = []
    var correctMatches: [String] = []
    var viewController: UIViewController?

    
    var shapeStartingLocations = [CGPoint?](repeating: nil, count:4)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        //image names for the shape game
        let shapeImageNames = ["square", "triangle", "circle", "rectangle", "hexagon", "pentagon", "octagon", "star"]
        //shape hole names
        let holeImageNames = ["square_hole", "triangle_hole", "circle_hole", "rectangle_hole", "hexagon_hole", "pentagon_hole", "octagon_hole", "star_hole"]
        //shape limit to be displayed
        let onScreenShapeCount = 4;//# of shapes on screen
        let onScreenHoleCount = 8;//# of holes on screen
        //Empty array to be filled randomly with the image names
        self.shapesOnScreen = []
        self.holesOnScreen = []
        self.background.name = "background"
        self.background.size = self.frame.size
        self.background.anchorPoint = CGPoint.zero
        self.background.zPosition = 0.0
        let screenSize = self.frame.size
        // 2 - add the background
        self.addChild(background)
        // Play Music
        playMusic(filename: "winter.mp3")
        
        
        //Generates the shape sprites on the screen
        for i in 0..<onScreenShapeCount {
            var imageName: String
            repeat {
                imageName = shapeImageNames[Int(arc4random_uniform(UInt32(shapeImageNames.count)))]
            } while shapesOnScreen.contains(imageName)
            shapesOnScreen.append(imageName)
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            // All shapes are named in the format "animal.*animalType*" for example "animal.bear"
            sprite.name = kShapeNodeName + "." + imageName
            
            // Resize sprite based on screen size
            let spriteSizeRatio = sprite.size.height/sprite.size.width
            var spriteSize: CGSize = screenSize
            spriteSize.height = screenSize.height * 0.2
            spriteSize.width = spriteSize.height * spriteSizeRatio
            sprite.size = spriteSize
            
            let xOffset = (i%2 > 0) ? CGFloat(0.25) : CGFloat(0.75)
            let yOffset = CGFloat(CGFloat(i+1)/CGFloat(onScreenShapeCount+1))
            sprite.position = CGPoint(x: size.width/2 * xOffset, y: size.height * yOffset)
            sprite.zPosition = 2.0
            
            shapeStartingLocations[i] = sprite.position//List of where each shape (0-3) began
            self.addChild(sprite)
        }
        //Generates the hole sprites on the screen
        for i in 0..<onScreenHoleCount {
            var imageName: String
            repeat {
                imageName = holeImageNames[Int(arc4random_uniform(UInt32(holeImageNames.count)))]
            } while holesOnScreen.contains(imageName)
            holesOnScreen.append(imageName)
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = kHoleNodeName + "." + imageName
            
            // Resize sprite based on screen size
            let spriteSizeRatio = sprite.size.height/sprite.size.width
            var spriteSize: CGSize = screenSize
            spriteSize.height = screenSize.height * 0.2
            spriteSize.width = spriteSize.height * spriteSizeRatio
            sprite.size = spriteSize
            
            let xOffset = (CGFloat(i) < CGFloat(onScreenHoleCount) * 0.5) ? CGFloat(1.30) : CGFloat(1.75)
            let yOffset = (i < 4) ? CGFloat(CGFloat(i+1)/((CGFloat(onScreenHoleCount)/2)+1.0)) : CGFloat(CGFloat(i-3)/((CGFloat(onScreenHoleCount)/2)+1.0))
            
            sprite.position = CGPoint(x: size.width/2 * xOffset, y: size.height * yOffset)
            sprite.zPosition = 1.0
            
            self.addChild(sprite)
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        
        selectNodeForTouch(positionInScene)
    }
    
    
    //Function Concerning the un-touching of all sprites
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        
        let touchedNodes = self.nodes(at: positionInScene)//the nodes being touched on the display
    
        let touchedNode = self.atPoint(positionInScene)
        
        // Handle replay button touch when victory card is displayde
        if touchedNode.name == "replayButton" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentVC = self.viewController
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SelectMatchingGameViewController")
            self.removeAllChildren()
            currentVC?.present(destinationVC, animated: true, completion: nil)
            
        } // Handle home button touch when victory card is displayed
        else if touchedNode.name == "homeButton" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentVC = self.viewController
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
            self.removeAllChildren()
            currentVC?.present(destinationVC, animated: true, completion: nil)
        }
    
        if nodeIsAShape(node: touchedNodes[0] as! SKSpriteNode){//if there is a shape being touched
            if nodeIsAHole(node: touchedNodes[1] as! SKSpriteNode) && getShapeOfHole(node: touchedNodes[1] as! SKSpriteNode) == (getShape(node: touchedNodes[0] as! SKSpriteNode)) {
                //CORRECT MATCH
                if !correctMatches.contains(getShape(node: touchedNodes[0] as! SKSpriteNode)) {
                    correctMatches.append(getShape(node: touchedNodes[0] as! SKSpriteNode))
                    
                    //Animate correct placement
                    correctShapePlacement(shape: touchedNodes[0] as! SKSpriteNode, hole: touchedNodes[1] as! SKSpriteNode)
                }
                touchedNodes[0].run(returnToInitialState(sprite: touchedNodes[0] as! SKSpriteNode))
                
                if correctMatches.count == 4 {
                    //self.run(SKAction.wait(forDuration: 0.8))
                    //self.run(displayVictoryCard())
                    self.run(SKAction.sequence([SKAction.wait(forDuration: 1.5), displayVictoryCard()]))
                    print("Winner! You have matched all the shapes with their respective holes")
                }
                
            } else if nodeIsAHole(node: touchedNodes[1] as! SKSpriteNode) && getShapeOfHole(node: touchedNodes[1] as! SKSpriteNode) != getShape(node: touchedNodes[0] as! SKSpriteNode) {
                //Animate incorrect placement
                let flip = SKAction.rotate(byAngle: degToRad(360), duration: 1)
                
                incorrectShapePlacement(shape: touchedNodes[0] as! SKSpriteNode, hole: touchedNodes[1] as! SKSpriteNode)
                
                touchedNodes[0].run(flip)
            }
        }
        
        
        
        
    }
    
    func degToRad(_ degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    
    /*
     * Determines if the node is a shape
     */
    func nodeIsAShape(node: SKSpriteNode) -> Bool {
        let nodeName = node.name?.components(separatedBy: ".")
        if nodeName?[0] == "shape" {
            return true
        } else {
            return false
        }
    }
    
    /*
     * Determines if the node is a hole
     */
    func nodeIsAHole(node: SKSpriteNode) -> Bool {
        let nodeName = node.name?.components(separatedBy: ".")
        if nodeName?[0] == "hole" {
            return true
        } else {
            return false
        }
    }
    
    /*
     * Returns the shape of the node
     */
    func getShape(node: SKSpriteNode) -> String {
        let shape = node.name?.components(separatedBy: ".")
        print(shape![1])
        return shape![1]
    }
    
    /*
     * Returns the shape of the hole of the node
     */
    func getShapeOfHole(node: SKSpriteNode) -> String {
        let holeDotShape = node.name?.components(separatedBy: "_")
        let theShape = holeDotShape?[0].components(separatedBy: ".")
        print(theShape![1])
        return theShape![1]
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
    
    func selectNodeForTouch(_ touchLocation: CGPoint) {
        // 1
        let touchedNode = self.atPoint(touchLocation)
        if touchedNode is SKSpriteNode {
            // 2
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                selectedNode = touchedNode as! SKSpriteNode
                // 3
                if nodeIsAShape(node: touchedNode as! SKSpriteNode) {
                    let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(-4.0), duration:0.1),
                                                      SKAction.rotate(byAngle: 0.0, duration: 0.1),
                                                      SKAction.rotate(byAngle: degToRad(4.0), duration: 0.1)])
                    selectedNode.run(SKAction.repeatForever(sequence), withKey: "shake")
                }
            }
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
        
        if nodeIsAShape(node: selectedNode) {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        } else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            background.position = self.boundLayerPos(aNewPosition)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)

        panForTranslation(translation)
    }
    
    
    
    /*
     *
     * Animations for correct and incorrect shape placement
     *
     */
    
    
    func correctShapePlacement(shape: SKSpriteNode, hole: SKSpriteNode) {
        let animationTime = 0.8
        
        //Move shape over hole
        let holeLocation = hole.position
        let cover = SKAction.move(to: holeLocation, duration: animationTime)
        let spin = SKAction.rotate(byAngle: 2.2, duration: animationTime)
        let fall = SKAction.scale(by: 0.1, duration: animationTime)
        let leave = SKAction.removeFromParent()
        let sink = SKAction.fadeOut(withDuration: animationTime)
        let spinFall = SKAction.group([spin, fall, sink])
        let coverAndFall = SKAction.sequence([cover, spinFall, leave])
        shape.run(coverAndFall)
    }
    
    func incorrectShapePlacement(shape: SKSpriteNode, hole: SKSpriteNode) {
        
        let animationTime = 0.8
        //Send shape back to original position
        let holeLocation = hole.position
        let cover = SKAction.move(to: holeLocation, duration: animationTime)
        
        // Move shape back to starting location
        let shapeLocation = shape.position
        let path = CGMutablePath()
        path.move(to: CGPoint(x: shapeLocation.x, y: shapeLocation.y))
        path.addLine(to: CGPoint(x: (shapeStartingLocations[Int(arc4random_uniform(UInt32(3)))]?.x)!, y: (shapeStartingLocations[Int(arc4random_uniform(UInt32(3)))]?.y)!))
        let followLine = SKAction.follow(path, asOffset: false, orientToPath: false, duration: animationTime)
        
        // Flip animal 360 degrees
        let flip = SKAction.rotate(byAngle: degToRad(360), duration: animationTime)
        
        // Execute animations
        let returnShape = SKAction.group([followLine, flip])
        let finalSequence = SKAction.sequence([returnShape, returnToInitialState(sprite: selectedNode)])
        
        
        
        selectedNode.run(cover)
        selectedNode.run(finalSequence)
    }
    
    
    // Display end of game options card
    func displayVictoryCard() -> SKAction {
        return SKAction.run {
            
            // Display victory card
            let victoryCard = SKSpriteNode(imageNamed: "shapeGameVictory")
            let cardSizeRatio = self.frame.size.height/self.frame.size.width
            let cardWidth = self.frame.size.width*(2/3)
            let cardHeight = cardWidth*cardSizeRatio
            victoryCard.size = CGSize(width: cardWidth, height: cardHeight)
            victoryCard.zPosition = cardPriority.victory
            victoryCard.position.x = self.frame.size.width/2
            victoryCard.position.y = self.frame.size.height/2
            victoryCard.name = "victoryCard"
            self.addChild(victoryCard)
            
            // Create replay button
            let replayButton = SKSpriteNode(imageNamed: "replay_btn")
            replayButton.size = CGSize(width: cardWidth/5, height: cardHeight/4)
            replayButton.zPosition = cardPriority.victory+1
            replayButton.position.x = victoryCard.position.x - cardWidth/5
            replayButton.position.y = victoryCard.position.y - cardHeight/6
            replayButton.name = "replayButton"
            self.addChild(replayButton)
            
            // Create home button
            let homeButton = SKSpriteNode(imageNamed: "home_btn")
            homeButton.size = CGSize(width: cardWidth/5, height: cardHeight/4)
            homeButton.zPosition = cardPriority.victory+1
            homeButton.position.x = victoryCard.position.x + cardWidth/5
            homeButton.position.y = victoryCard.position.y - cardHeight/6
            homeButton.name = "homeButton"
            self.addChild(homeButton)
            
        }
    }

    
    
    
    
    
}
