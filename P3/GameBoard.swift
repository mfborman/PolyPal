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

    private let board: CGRect
    private let rowCount: Int
    private let columnCount: Int
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init (board: CGRect, rowCount: Int, columnCount: Int) {
        self.board = board
        self.rowCount = rowCount
        self.columnCount = columnCount
        
        super.init(texture: SKTexture(imageNamed: "memory_bgrnd"), color: .clear, size: CGSize(width: board.width, height: board.height))
        
        self.name = "gameBoard"
        self.zPosition = cardPriority.background+1
        self.size = board.size
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    /*
     * Fills the board with card from a given card array. The board is filled left to right, top to bottom
     * by itterating through the array of size n from [0] to [n]
     *
     * Parameters: A list of cards to fill the board with
     */
    func fillWithCards(cardList: [Card]) {
        
        let xOffset = board.width / CGFloat(columnCount)
        let yOffset = board.height / CGFloat(rowCount)
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
