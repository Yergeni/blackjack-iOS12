//
//  Hand.swift
//  BlackJack
//
//  Created by Testing on 10/8/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation


class Hand {
    
    final var deck: [Card]
    
    init() {
        self.deck = []
    }
    
    // Generate the deck
    func generateDeck() -> [Card] {
        
        var cards: [Card] = []
        let faces = ["A": 1,"2": 2,"3": 3,"4": 4,"5": 5,"6": 6,"7": 7,"8": 8,"9": 9,"10": 10,"J": 10,"Q": 10,"K": 10 ]
        let suits = ["H","S","D","C"]
        
        for suit in suits {
            for face in faces{
                let card = Card(face: face.key, suit: suit, value: face.value)
                cards.append(card)
            }
        }
        
        self.deck = cards.shuffled()
        return self.deck
    }
    
    // MARK: Game functions
    func summationValueCards() {
    }
    
    func hasBlackjack() {
    }
    
    func gotBust() {
    }
}
