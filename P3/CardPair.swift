//
//  CardPair.swift
//  P3
//
//  Created by Mitchell Borman on 11/3/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import Foundation
import SpriteKit

class CardPair: SKSpriteNode {
    
    var cards : [Card]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init() {
        cards = []
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 0.0, height: 0.0))
    }
    
    func getCards() -> [Card] {
        return cards
    }
    
    func full() -> Bool {
        if cards.count == 2 {
            return true
        } else {
            return false
        }
    }
    
    func addCard(card: Card) {
        if cards.count == 2 {
            cards.removeAll()
        }
        cards.append(card)
    }
    
    func matches() -> Bool {
        if cards.count == 2 && cards[0].cardType == cards[1].cardType {
            return true
        } else {
            return false
        }
    }
    
    func handlePossibleMatch(newCard: Card) -> SKAction {
        return SKAction.run {
            self.addCard(card: newCard)
            if self.full() {
                if self.matches() {
                    self.cards[1].delete()
                    self.cards[0].delete()
                } else {
                    self.cards[0].hide(withCard: self.cards[1])
                }
            }
        }
        
    }
    
}
