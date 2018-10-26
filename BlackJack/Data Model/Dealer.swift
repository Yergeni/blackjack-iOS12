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
    let player: Player
    
    init() {
        self.cards = []
        player = Player()
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
        
        if card.face == "A" && summationValueCards() > 10 {
            card.value = 1
        }
        
        if summationValueCards() + card.value > 21 {
            changeAsValueToOne()
        }
        
        self.cards.append(card)
    }
    
    func changeAsValueToOne() {
        for card in cards {
            if card.face == "A" { card.value = 1 }
        }
    }
    
    func hasBlackjack() -> Bool {
        
        return cards[0].value + cards[1].value == 21
    }
    
    func gotBust() -> Bool {
        
        return summationValueCards() > 21
    }
}
