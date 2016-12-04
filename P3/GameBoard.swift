//
//  GameBoard.swift
//  P3
//
//  Created by Mitchell Borman on 11/8/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import Foundation
import SpriteKit

class GameBoard: SKSpriteNode{

    private let rowCount: Int
    private let columnCount: Int
    let width: CGFloat
    let height: CGFloat
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init (width: CGFloat, height: CGFloat, boardSize6by6: Bool) {
       
        if (boardSize6by6) {
            self.rowCount = 6
        } else {
            self.rowCount = 4
        }
        self.columnCount = rowCount
        self.width = width
        self.height = height
        
        super.init(texture: SKTexture(imageNamed: "memory_bgrnd"), color: .clear, size: CGSize(width: width, height: height))
        
        self.name = "gameBoard"
        self.zPosition = cardPriority.background+1
        self.size = CGSize(width: width, height: height)
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    /*
     * Fills the board with card from a given card array. The board is filled left to right, top to bottom
     * by itterating through the array of size n from [0] to [n]
     *
     * Parameters: A list of cards to fill the board with
     */
    func fillWithCards(cardList: [Card]) {
        
        let xOffset = width / CGFloat(columnCount)
        let yOffset = height / CGFloat(rowCount)
        var cardIndex = 0
        
        for i in 0..<rowCount {
            for j in 0..<columnCount {
                let card = cardList[cardIndex]
                
                card.position.x = CGFloat(j)*xOffset + card.size.width/2
                card.position.y = CGFloat(i)*yOffset + card.size.height/2
                card.zPosition = cardPriority.standard
                card.gamePosition = card.position
                self.addChild(card)
                cardIndex += 1
            }
        }
    }
    
}
