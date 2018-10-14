//
//  Dealer.swift
//  BlackJack
//
//  Created by Testing on 10/8/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation

class Dealer {
    
    var cards: [Card]
    
    init() {
        self.cards = []
    }
    
    //MARK: Override game functions
    func summationValueCards() -> Int {
        var sum = 0
        
        for card in self.cards {
            sum += card.value
        }
        
        return sum
    }
    
    func addCard(card: Card) {
        
        if card.face == "A" && summationValueCards() >= 11 {
            card.value = 1
            self.cards.append(card)
        } else { self.cards.append(card) }
    }
    
    func hasBlackjack() -> Bool {
        
        return summationValueCards() == 21
    }
    
    func gotBust() -> Bool {
        
        return summationValueCards() > 21
    }
}
