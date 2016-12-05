//
//  Utilities.swift
//  P3
//
//  Created by Mitchell Borman on 11/2/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

// Define zPositions for matching game
struct cardPriority {
    static let background: CGFloat = 0.0
    static let standard  : CGFloat = 5.0
    static let moving    : CGFloat = 10.0
    static let victory   : CGFloat = 15.0
}

// Define zPositions for animal game
struct depth {
    static let background    : CGFloat = 0.0
    static let barn          : CGFloat = 1.0
    static let label         : CGFloat = 2.0
    static let animal        : CGFloat = 3.0
}

// Randomizes an array
func randomizeArray<T>(_ array: inout [T]) {
    for i in 0..<array.count {
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        let value = array[randomIndex]
        array[randomIndex] = array[i]
        array[i] = value
    }
}

// Play background music
var backgroundMusicPlayer = AVAudioPlayer()

//Background music function
func playMusic(filename: String) {
    let url = Bundle.main.url(forResource: filename, withExtension: nil)
    guard let newURL = url else {
        print("Could not find file: \(filename)")
        return
    }
    do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    } catch let error as NSError {
        print(error.description)
    }
}
