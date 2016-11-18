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
    var nilCard = Card(cardType: "")
    var selectedCard: Card
    
    override init(size: CGSize) {
        pair = CardPair()
        selectedCard = nilCard

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
        
        // Create the game board
        let gameBoard = GameBoard(width: screenWidth, height: screenHeight, rowCount: rowSize, columnCount: columnSize
        )
        
        // Create cards in array
        for i in 0..<uniqueCardCount {
            
            // Set up card
            let card = Card(cardType: cardImageList[i])
            //TODO: Remake cards to match ratios of screen so we don't have to 
            let cardSizeRatio = screenHeight/screenWidth
            let cardWidth = gameBoard.width/CGFloat(rowSize)
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
        
        gameBoard.fillWithCards(cardList: generatedCards)
        self.addChild(gameBoard)

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
            if !selectedCard.beingViewed {
                selectedCard = card
            }
            // If card has not yet been viewed pop-down
            if !card.beingViewed && !selectedCard.beingViewed {
                card.run(SKAction.scale(to: 0.9, duration: accentDuration))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if touchedNode is Card {
            let card: Card = touchedNode as! Card
            
            if !card.faceUp && !card.beingViewed && card == selectedCard {
                // Reveal the card
                //TODO: If a card is being viewed, any screen touch should return it to board
                let revealCard = card.revealCard()
                let waitForAnimationCompletion = SKAction.wait(forDuration: card.getRevealAnimationTime())
                let checkForMatch = pair.handlePossibleMatch(newCard: card)
                let handleCardFlip = SKAction.sequence([revealCard, waitForAnimationCompletion, checkForMatch])
                self.run(handleCardFlip)
                
            }
            if !selectedCard.beingViewed {
                selectedCard.run(SKAction.scale(to: 1.0, duration: 0.1))
            }

        }

    }
}
