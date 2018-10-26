//
//  ViewController.swift
//  BlackJack
//
//  Created by Testing on 9/2/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit
import Firebase

class BlackjackViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var testDeck = [
        Card(face: "10", suit: "S", value: 10), //p
        Card(face: "A", suit: "H", value: 11), //d
        Card(face: "9", suit: "S", value: 9), //p
        Card(face: "8", suit: "C", value: 8), //d
        
        Card(face: "2", suit: "H", value: 2), //p
        Card(face: "3", suit: "H", value: 3), //d
        Card(face: "8", suit: "D", value: 8), //p
        Card(face: "A", suit: "C", value: 11), //d
        Card(face: "3", suit: "S", value: 3),
        Card(face: "A", suit: "S", value: 11),
        Card(face: "A", suit: "D", value: 11),
    ]
    
    var documentID : String?
    var deck: [Card] = []
    var player: Player = Player()
    var dealer: Dealer = Dealer()
    let hand: Hand = Hand()
    let game: Game = Game()
    
    @IBOutlet weak var dealerCollectionView: UICollectionView!
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var betBoxLabel: UILabel!
    @IBOutlet weak var playerMoneyLabel: UILabel!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var stanButton: UIButton!
    @IBOutlet weak var doubledownButton: UIButton!
    @IBOutlet weak var splitButton: UILabel!
    @IBOutlet weak var playerCardTotalValues: UILabel!
    @IBOutlet weak var dealerCardTotalvalues: UILabel!
    
    
    //MARK: Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize UI
        playerLabel.text = player.nickname
        updatePlayerMoneyLabel()
        updateBetLabelField(amount: player.betBox)
        
        // disable buttons
        disableButtonActions()
        
        
        // generating the deck
        //self.deck = hand.generateDeck()
        self.deck = testDeck
        
        
        dealerCollectionView.delegate = self
        dealerCollectionView.dataSource = self
        
        playerCollectionView.delegate = self
        playerCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        generateBetAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Player button actions
    @IBAction func hitButtonPressed(_ sender: UIButton) {
        
        handleGameByAction(action: player.actions[0])
    }
    
    @IBAction func stayButtonPressed(_ sender: UIButton) {
        
        handleGameByAction(action: player.actions[1])
    }
    
    @IBAction func doubleDownButtonPressed(_ sender: UIButton) {
        
        handleGameByAction(action: player.actions[2])
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch  {
            //TODO: Show an alert if error
            print("error, there was a problem signing out.")
        }
    }
    
    
    //MARK: - Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == dealerCollectionView {
            return dealer.cards.count
        } else {
            return player.cards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // var cell: UICollectionViewCell
        
        if collectionView == self.dealerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealerCollectionCell", for: indexPath) as! DealerCardCollectionViewCell
            
            cell.cardImage.image = UIImage(named: dealer.cards[indexPath.item].imageName)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCollectionCell", for: indexPath) as! PlayerCardCollectionViewCell
            
            cell.cardImage.image = UIImage(named: player.cards[indexPath.item].imageName)
            return cell
        }
    }
    
    
    //MARK: - Game handling
    
    func distributeCard(toPlayer: Player? = nil, toDealer: Dealer? = nil) {
        toPlayer?.addCard(card: deck.remove(at: 0))
        toDealer?.addCard(card: deck.remove(at: 0))
        
        dealerCollectionView.reloadData()
        playerCollectionView.reloadData()
        playerCardTotalValues.text = String(player.summationValueCards())
    }
    
    // Check for BJ before any actions
    func handleGameBeforeActions() {
        
        for _ in 1...2 {
            //TODO: try to make 0.5 seconds between card distribution
            distributeCard(toPlayer: player, toDealer: dealer)
        }
        
        dealer.cards[0].imageName = "red_back"
        // If player has blackjack hand is over
        if player.hasBlackjack() {
            handleDealerTurn()
        }
        
        if player.cards[0].face == player.cards[1].face {
            splitButton.isEnabled = true
        } else {
            hitButton.isEnabled = true
            stanButton.isEnabled = true
            doubledownButton.isEnabled = true
        }
    }
    
    func handleGameByAction(action: String) {

        switch action {
        case player.actions[0]:
            handleHitAction()
        case player.actions[1]:
            handleStandAction()
        case player.actions[2]:
            handleDoubledowndAction()
        case player.actions[3]:
            print("handle split action")
        default:
            handleDealerTurn()
        }
    }
    
    func handleHitAction() {
        
        // If hit doubledown action got disable
        doubledownButton.isEnabled = false
        distributeCard(toPlayer: player)
        
        if player.gotBust() {
            handleHandOver(state: 1)
        }
    }
    
    func handleDoubledowndAction() {
        
        // If doubledown actions got disable
        disableButtonActions()
        
        distributeCard(toPlayer: player)
        
        if player.gotBust() { handleHandOver(state: 1) }
        else { handleDealerTurn() }
    }
    
    func handleStandAction() {
        
        disableButtonActions()
        handleDealerTurn()
    }
    
    func handleDealerTurn() {
        
        // show the dealer hidden card to players
        dealer.cards[0].imageName = "\(dealer.cards[0].face)\(dealer.cards[0].suit)"
        dealerCollectionView.reloadData()
        
        // show the value of the cards
        dealerCardTotalvalues.text = String(dealer.summationValueCards())
        
        if dealer.hasBlackjack() && player.hasBlackjack() {
            //TODO: Handle match game
            disableButtonActions()
            handleHandOver(state: 0)
        } else if dealer.hasBlackjack() {
            // 'state' in 1 means that player loose the hand
            handleHandOver(state: 1)
        } else if player.hasBlackjack() {
            handleHandOver(state: 2)
        } else {
        
            while true {
                distributeCard(toDealer: dealer)
                
                dealerCardTotalvalues.text = String(dealer.summationValueCards())
                
                // 'state' in 2 means that dealer loose the hand, 1 player loose, 0 hand got match
                if dealer.gotBust() {
                    handleHandOver(state: 2)
                    break
                }
                else if dealer.summationValueCards() > player.summationValueCards() {
                    handleHandOver(state: 1)
                    break
                }
                else if !dealer.hasBlackjack() && dealer.summationValueCards() == 21 && player.summationValueCards() == 21 {
                    handleHandOver(state: 0)
                    break
                }
            }
        }
    }
    
    func handleHandOver(state: Int) {
        
        generateHandOverAlert(state: state)
    }
    
    func disableButtonActions() {
        
        hitButton.isEnabled = false
        stanButton.isEnabled = false
        doubledownButton.isEnabled = false
        hitButton.isEnabled = false
    }
    
    
    //MARK: - Alerts

    func generateBetAlert() {
        
        var betTextField = UITextField()
        var title: String
        
        // recomended bet 100% of your initial bet when 'Doubledown'
        if player.betBox > 0 {
            betTextField.placeholder = "Recomended bet: double bet box"
            title = "Dobledown BET"
        } else {
            betTextField.text = "0"
            title = "Let's start!!!"
        }
        
        let alert = UIAlertController(title: title, message: "Pease make a bet", preferredStyle: .alert)
        
        let betAction = UIAlertAction(title: "Place Bet!", style: .default) { (alertAction) in
            
            // What will happend once the user clicks the 'Place Bet!' action button on the UIAlert
            if betTextField.text != "" {
                
                let bet = Int(betTextField.text!)!
                
                if self.player.moneyAmount >= bet {
                    
                    // add the new bet to the player's betbox field
                    self.player.betBox += bet
                    // then substract the new bet
                    self.player.substractMoney()
                    // and update player money label
                    self.updatePlayerMoneyLabel()
                    
                    self.updateBetLabelField(amount: self.player.betBox)
                    
                    // put 0 to the betText field
                    betTextField.text = ""
                    
                    // distribute cards and handle game
                    self.handleGameBeforeActions()
                    
                } else {
                    //TODO: Show error on the alert to let player know that the bet cannot be placed
                    print("You do not have enough founds.")
                }
            } else {
                //TODO: Show error on the alert a number should be provided
                print("Please provide a number value.")
            }
        }
        
        // adding a text field input to the alert
        alert.addTextField { (betAlertTextField) in
            
            betTextField.placeholder = "Place your bet here"
            // A reference to the textField variable created previouuly
            betTextField = betAlertTextField
            
        }
        
        // Adding the action to the alert
        alert.addAction(betAction)
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    func generateHandOverAlert(state: Int) {
        var title = "MATCH HAND!!!"
        
        // if state = 1 means Player loose, state = 2 means dealer loose
        if state == 1 {
            title = "Oops Bad Luck. You lose."
        } else if state == 2 {
            title = "Congratulation!!! you won."
            
            if player.hasBlackjack() { player.addMoney(amount: player.betBox * 3) }
            else { player.addMoney(amount: player.betBox * 2) }
        } else {
            player.addMoney(amount: player.betBox)
        }
        
        let alert = UIAlertController(title: "\(title) Another Hand?", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            //TODO: Save values to firebase everytime a hand is over
            
            self.cleanUI()
            self.updatePlayerMoneyLabel()
            self.generateBetAlert()
            self.initializePlayerAndDealerAttributes()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
            
            //TODO: Save values to firebase everytime a hand is over
            
            self.cleanUI()
            self.initializePlayerAndDealerAttributes()
            
            // go back to game list
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Update UI infromation
    func updateBetLabelField(amount: Int) {
        betBoxLabel.text = "Bet box: $\(amount)"
    }
    
    func updatePlayerMoneyLabel() {
        playerMoneyLabel.text = "Money: $\(self.player.moneyAmount)"
    }
    
    func reloadCollectionViewData() {
        dealerCollectionView.reloadData()
        playerCollectionView.reloadData()
    }
    
    func cleanUI() {
        player.cards.removeAll()
        dealer.cards.removeAll()
        player.betBox = 0
        //deck = hand.generateDeck()
        updateBetLabelField(amount: 0)
        reloadCollectionViewData()
        playerCardTotalValues.text = ""
        dealerCardTotalvalues.text = ""
    }
    
    func initializePlayerAndDealerAttributes() {
        player.cards = []
        dealer.cards = []
    }
    
}

