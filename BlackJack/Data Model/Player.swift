//
//  Player.swift
//  BlackJack
//
//  Created by Testing on 10/8/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation

class Player {
    
    var cards: [Card]
    var name: String
    var moneyAmount: Int
    var betBox: Int
    
    init(name: String = "Player", money: Int = 0) {
        
        self.cards = []
        self.name = name
        self.moneyAmount = money
        self.betBox = 0
    }
    
    //MARK: game functions
    func summationValueCards() -> Int {
        var sum = 0
        
        for card in self.cards {
            sum += card.value
        }
        
        return sum
    }
    
    func hasBlackjack() -> Bool {
        
        return summationValueCards() == 21
    }
    
    func gotBust() -> Bool {
        
        return summationValueCards() > 21
    }
}
