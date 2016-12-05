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
    
    var viewController: UIViewController?
    var pair : CardPair
    var nilCard = Card(cardType: "")
    var selectedCard: Card
    var boardSize6by6 = Bool()
    var generatedCards: [Card]
    var cardsToGenerate: [String]
    var uniqueCardCount = Int()
    var numberOfMatches = Int()
    var screenSize = CGSize()
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    override init(size: CGSize) {
        pair = CardPair()
        selectedCard = nilCard
        generatedCards = []
        cardsToGenerate = []

        super.init(size: size)
        
    }
    
    func settup() {
        // Define basic variables
        let cardImageList = ["apple", "backpack", "camera", "car", "caterpillar", "cellphone", "dog", "football", "guitar", "hamburger", "hat", "mug", "pen", "schoolbus", "tent", "toaster", "vacuum", "whistle"]
        let numberOfCards = boardSize6by6 ? 36 : 16
        uniqueCardCount = numberOfCards/2
        numberOfMatches = 0
        screenSize = self.frame.size
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Create the game board
        let gameBoard = GameBoard(width: screenWidth, height: screenHeight, boardSize6by6: boardSize6by6)
        
        // Create cards in array
        while cardsToGenerate.count < uniqueCardCount {
            
            var imageName: String
            repeat {
                imageName = cardImageList[Int(arc4random_uniform(UInt32(uniqueCardCount)))]
            } while cardsToGenerate.contains(imageName)
            cardsToGenerate.append(imageName)
            
        }
        for i in 0..<cardsToGenerate.count {
        
            // Set up card
            let card = Card(cardType: cardsToGenerate[i])
            //TODO: Remake cards to match ratios of screen so we don't have to
            let cardSizeRatio = screenHeight/screenWidth
            let cardWidth = gameBoard.width/CGFloat(sqrt(Double(numberOfCards)))
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
    
    // Display end of game options card
    func displayVictoryCard() -> SKAction {
        return SKAction.run {
            
            // Display victory card
            let victoryCard = SKSpriteNode(imageNamed: "matchingGameVictory")
            let cardSizeRatio = self.frame.size.height/self.frame.size.width
            let cardWidth = self.frame.size.width*(2/3)
            let cardHeight = cardWidth*cardSizeRatio
            victoryCard.size = CGSize(width: cardWidth, height: cardHeight)
            victoryCard.zPosition = cardPriority.victory
            victoryCard.position.x = self.screenWidth/2
            victoryCard.position.y = self.screenHeight/2
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
    
    // Remove end of game options card
    func removeVictoryCard() -> SKAction {
        return SKAction.run {
            
        }
    }
    
    func homeButtonAction(sender: UIButton) {
        if sender.tag == 2 {
            // Return to home screen
        }
    }
    
    func replayButtonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            self.run(removeVictoryCard())
        }
    }
    
    func markMatch() -> SKAction {
        return SKAction.run {
            if self.pair.matches() {
                self.numberOfMatches += 1
            }
            if  self.numberOfMatches == 1 {//self.uniqueCardCount {
                
                self.run(self.displayVictoryCard())
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        // Handle replay button touch when victory card is displayde
        if touchedNode.name == "replayButton" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentVC = self.viewController
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SelectMatchingGameViewController")
            self.removeAllChildren()
            currentVC?.present(destinationVC, animated: true, completion: nil)
            
        } // Handle home button touch when victory card is displayde
        else if touchedNode.name == "homeButton" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let currentVC = self.viewController
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
            self.removeAllChildren()
            currentVC?.present(destinationVC, animated: true, completion: nil)
            
        } // Handle card touches during game
        else if touchedNode is Card {

            let card: Card = touchedNode as! Card
            
            if !card.faceUp && !card.beingViewed && card == selectedCard {
                // Reveal the card
                //TODO: If a card is being viewed, any screen touch should return it to board
                let revealCard = card.revealCard()
                let waitForAnimationCompletion = SKAction.wait(forDuration: card.getRevealAnimationTime())
                let handlePossibleMatch = pair.handlePossibleMatch(newCard: card)
                let handleCardFlip = SKAction.sequence([revealCard, waitForAnimationCompletion, handlePossibleMatch, markMatch()])
                self.run(handleCardFlip)               
            }
        }
        if !selectedCard.beingViewed {
            selectedCard.run(SKAction.scale(to: 1.0, duration: 0.1))
        }

    }
}
