//
//  Card.swift
//  BlackJack
//
//  Created by Testing on 10/8/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation

class Card {
    
    let face: String
    let imageName: String
    let suit: String
    var value: Int
    
    init(face: String, suit: String, value: Int) {
        
        self.face = face
        self.imageName = "\(face)\(suit)"
        self.suit = suit
        self.value = value
    }
}
