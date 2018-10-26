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
    var nickname: String
    var moneyAmount: Int
    var betBox: Int
    final let actions = ["HIT", "STAND", "DD", "SPLIT"]
    
    init(nickname: String = "Player", money: Int = 0) {
        
        self.cards = []
        self.nickname = nickname
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
    
    func addMoney(amount: Int) {
        self.moneyAmount += amount
    }
    
    func substractMoney() {
        
        if moneyAmount >= betBox {
            self.moneyAmount -= betBox
        }
    }
}
