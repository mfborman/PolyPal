//
//  Card.swift
//  P3
//
//  Created by Mitchell Borman on 11/2/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import Foundation
import SpriteKit

class Card: SKSpriteNode {
    let cardType : String
    let frontTexture : SKTexture
    let backTexture : SKTexture
    var gamePosition : CGPoint
    var faceUp : Bool
    var beingViewed : Bool
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(cardType: String) {
        self.cardType = cardType
        backTexture = SKTexture(imageNamed: "card_back")
        frontTexture = SKTexture(imageNamed: cardType)
        gamePosition = CGPoint()
        faceUp = false
        beingViewed = false
        
        super.init(texture: backTexture, color: .clear, size: frontTexture.size())
                
    }
    
    // Flips a card over
    func flipCard() -> SKAction {
        return SKAction.run {
            if (self.faceUp) {
                self.texture = self.backTexture
                self.faceUp = false
            } else {
                self.texture = self.frontTexture
                self.faceUp = true
            }
        }
    }
    
    private func deleteCardFromScene() -> SKAction {
        return SKAction.run {
            self.removeFromParent()
        }
    }
    
    func movingPriority() -> SKAction {
        return SKAction.run {
            self.zPosition = cardPriority.moving
        }
    }
    
    func standardPriority() -> SKAction {
        return SKAction.run {
            self.zPosition = cardPriority.standard
        }
    }
    
    func reveal() {
        let totalAnimationTime = 0.4
        let screenWidth = self.parent?.frame.size.width
        let screenHeight = self.parent?.frame.size.height
        
        // Move card to center of screen
        let moveToCenter = SKAction.move(to: CGPoint(x: screenWidth!/2, y: screenHeight!/2), duration: totalAnimationTime)
        
        // Grow card to double size
        let doubleSize = SKAction.scale(to: 3.0, duration: totalAnimationTime)
        
        // Flip card's texture from back to front
        let flipCard = self.flipCard()
        let flipDelay = SKAction.wait(forDuration: totalAnimationTime/2)
        let delayedFlip = SKAction.sequence([flipDelay, flipCard])
        
        
        // Give card priority in view
        let givePriority = movingPriority()
        
        // Complete card reveal
        let revealCard = SKAction.group([moveToCenter, delayedFlip, doubleSize])
        
        // Animate
        let finalSequence = SKAction.sequence([givePriority, revealCard])
        self.run(finalSequence)
        
        beingViewed = true
    }
    
    func returnToLocation() -> SKAction {
        return SKAction.run {
        let totalAnimationTime = 0.4
        
        // Move back to initial location
        let returnToStartingLocation = SKAction.move(to: self.gamePosition, duration: totalAnimationTime)
        
        // Shrink back to normal size
        let returnToStartingSize = SKAction.scale(to: 1.0, duration: totalAnimationTime)
        
        // Revoke priority in view
        let revokePriority = self.standardPriority()
        
        // Group actions
        let completeMove = SKAction.group([returnToStartingLocation, returnToStartingSize])
       
        // Animate
        let finalSequence = SKAction.sequence([completeMove, revokePriority])
        self.run(finalSequence)
        
        self.beingViewed = false
        }
    }
    
    func hide() -> SKAction {
        return SKAction.run {
            let popUp = SKAction.scale(to: 1.2, duration: 0.1)
            let popDown = SKAction.scale(to: 1.0, duration: 0.1)
            let hideSequence = SKAction.sequence([popUp, self.flipCard(), popDown])
            self.run(hideSequence)
        }
    }
    
    func hide(withCard: Card) {
        let hideOne = self.hide()
        let hideTwo = withCard.hide()
        let timeBetweenHides = SKAction.wait(forDuration: 0.2)
        let sequentialHide = SKAction.sequence([hideOne, timeBetweenHides, hideTwo])
        self.run(sequentialHide)
    }
    
    func delete() {
        let actionDuration = 0.5
        let fade = SKAction.fadeOut(withDuration: actionDuration)
        let rise = SKAction.moveBy(x: 0.0, y: self.size.height, duration: actionDuration)
        let deleteAction = SKAction.group([fade, rise])
        let finalRemoval = SKAction.sequence([deleteAction, deleteCardFromScene()])
        self.run(finalRemoval)
    }
}
