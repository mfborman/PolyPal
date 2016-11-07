//
//  MatchingGameScene.swift
//  P3
//
//  Created by Mitchell Borman on 11/2/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import SpriteKit
import Foundation

class MatchingGameScene: SKScene {
    
    var pair : CardPair
    let background = SKSpriteNode(imageNamed: "memory_bgrnd")
    
    override init(size: CGSize) {
        pair = CardPair()

        super.init(size: size)
        
        // Define basic variables
        let cardImageList = ["caterpillar", "cellphone", "football", "car", "mug", "tent", "pen", "camera"]
        var generatedCards : [Card] = []
        let cardCount = 8
        let screenSize = self.frame.size
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        // Create background
        self.background.name = "background"
        self.background.size = screenSize
        self.background.anchorPoint = CGPoint.zero
        self.addChild(background)
        self.background.zPosition = cardPriority.background
        
        // Create cards in array
        for i in 0..<cardCount {
            
            // Set up card
            let card = Card(cardType: cardImageList[i])
            let cardSizeRatio = card.size.height/card.size.width
            let cardWidth = screenWidth/CGFloat(cardCount/2+1)
            let cardHeight = cardWidth*cardSizeRatio
            card.size = CGSize(width: cardWidth, height: cardHeight)
            card.zPosition = cardPriority.standard
            card.name = "\(i)"
            
            // Set up card match
            let cardMatch = Card(cardType: cardImageList[i])
            cardMatch.size = card.size
            cardMatch.zPosition = cardPriority.standard
            cardMatch.name = "\(i)"
            
            // Add cards to scene
            generatedCards.append(card)
            generatedCards.append(cardMatch)

        }
        
        // Randomize card array
        //TODO: Move this code and the code in alphabet to method in utilites
        //TODO: Look into a better randomization algorithm
        for i in 0..<cardCount*2 {
            let rand = Int(arc4random_uniform(UInt32(cardCount*2)))
            let randomCardToSwap = generatedCards[rand]
            generatedCards[rand] = generatedCards[i]
            generatedCards[i] = randomCardToSwap
            print ("Swapped card \(i) with card \(rand)")
        }
        
        // Place cards on screen
        for i in 0..<cardCount*2 {
            let card = generatedCards[i]
            let xOffset: CGFloat
            let column = i%4
            switch column {
                case 0: xOffset = 0.25
                case 1: xOffset = 0.75
                case 2: xOffset = 1.25
                default: xOffset = 1.75
            }
            let yOffset: CGFloat
            let row: Int = i/4
            print ("Row = \(row)")
            switch row {
                case 0: yOffset = 0.25
                case 1: yOffset = 0.75
                case 2: yOffset = 1.25
                default: yOffset = 1.75
            }
            card.position = CGPoint(x: size.width/2 * xOffset, y: size.height/2 * yOffset)
            card.gamePosition = card.position
            self.background.addChild(card)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        let accentDuration = 0.1
        if touchedNode is Card {
            let card: Card = touchedNode as! Card
            // If viewing card pop-up
            if card.beingViewed {
                card.run(SKAction.scale(by: 1.2, duration: accentDuration))
            // If card has not yet been viewed pop-down
            } else if !card.beingViewed && !card.faceUp {
                card.run(SKAction.scale(to: 0.8, duration: accentDuration))
            // If card is face up but not being viewed pop-down then pop-up
            } else {
                card.run(SKAction.sequence([SKAction.scale(to: 0.8, duration: accentDuration),
                                            SKAction.scale(to: 1.0, duration: accentDuration)]))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if touchedNode is Card {
            
            let card: Card = touchedNode as! Card

            //TODO: If a card is being viewed, return it to original position from touch ANYWHERE on screen
            //if card.beingViewed {
                
                //let moveCardBack = card.returnToLocation()
                //let checkForMatch = pair.handlePossibleMatch(newCard: card)
                //self.run(SKAction.sequence([moveCardBack, checkForMatch]))
                
            //} else if !card.beingViewed && !card.faceUp {
            if !card.faceUp {
                let revealCard = card.revealCard()
                let waitForAnimationCompletion = SKAction.wait(forDuration: card.getRevealAnimationTime())
                let checkForMatch = pair.handlePossibleMatch(newCard: card)
                let handleCardFlip = SKAction.sequence([revealCard, waitForAnimationCompletion, checkForMatch])
                self.run(handleCardFlip)
            }

            //}
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
