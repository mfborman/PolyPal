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
    
    override init(size: CGSize) {
        pair = CardPair()

        super.init(size: size)
        
        // Define basic variables
        let cardImageList = ["caterpillar", "cellphone", "football", "car", "mug", "tent", "pen", "camera"]
        var generatedCards : [Card] = []
        let numberOfCards = 16
        let rowSize = 4
        let columnSize = 4
        let uniqueCardCount = numberOfCards/2
        let screenSize = self.frame.size
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        // Create cards in array
        for i in 0..<uniqueCardCount {
            
            // Set up card
            let card = Card(cardType: cardImageList[i])
            //Ration based on image...let cardSizeRatio = card.size.height/card.size.width
            let cardSizeRatio = screenHeight/screenWidth
            let cardWidth = screenWidth/CGFloat(uniqueCardCount/2)
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
        
        // Randomize the array so that the cards will be shuffled on the board
        randomizeArray(&generatedCards)
        
        let gameBoard = GameBoard(board: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), rowCount: rowSize, columnCount: columnSize
        )
        self.addChild(gameBoard)
        (self.childNode(withName: "gameBoard") as! GameBoard).fillWithCards(cardList: generatedCards)

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
