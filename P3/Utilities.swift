//
//  Utilities.swift
//  P3
//
//  Created by Mitchell Borman on 11/2/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import Foundation
import SpriteKit

// Define zPositions for matching game
struct cardPriority {
    static let background: CGFloat = 0.0
    static let standard  : CGFloat = 1.0
    static let moving    : CGFloat = 10.0
}

// Define zPositions for animal game
struct depth {
    static let background    : CGFloat = 0.0
    static let barn          : CGFloat = 1.0
    static let label         : CGFloat = 2.0
    static let animal        : CGFloat = 3.0
}
