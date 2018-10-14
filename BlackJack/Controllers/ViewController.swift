//
//  ViewController.swift
//  BlackJack
//
//  Created by Testing on 9/2/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var deck: [Card] = []
    var player: Player = Player()
    var dealer: Dealer = Dealer()
    let hand: Hand = Hand()
    
    @IBOutlet weak var dealerCollectionView: UICollectionView!
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var betBoxLabel: UILabel!
    @IBOutlet weak var playerMoneyLabel: UILabel!
    
    
    //MARK: Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // generating the deck
        self.deck = hand.generateDeck()
        
        dealerCollectionView.delegate = self
        dealerCollectionView.dataSource = self
        
        playerCollectionView.delegate = self
        playerCollectionView.dataSource = self
        
        updateBetBoxTextField(amount: player.betBox)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        generatePlayerStartingAlert()
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
    }
    
    
    
    @IBAction func doubleDownButtonPressed(_ sender: UIButton) {
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
    }
    
    // Check for BJ before any actions
    func handleGameBeforeActions() {
        
        for _ in 1...2 {
            //TODO: try to make 0.5 between card distribution
            distributeCard(toPlayer: player, toDealer: dealer)
        }
        
        // If player has blackjack hand is over
        handleHandOver(state: player.hasBlackjack())
    }
    
    func handleGameByAction(action: String) {
        
        // first common checks
        if player.gotBust() {

        }

        switch action {
        case player.actions[0]:
            handleHitAction()
        default:
            print("Dealer turn")
        }
    }
    
    func handleHitAction() {
        
        distributeCard(toPlayer: player)
        
        if player.gotBust() {
            handleHandOver(state: true)
        }
    }
    
    func handleHandOver(state: Bool) {
        
        if state { generateHandOverAlert(state: state) }
        else {
            //TODO: Enable buttons
        }
    }
    
    
    //MARK: - Alerts
    func generatePlayerStartingAlert() {
        
        var nameTextField = UITextField()
        var moneyTextField = UITextField()
        
        let alert = UIAlertController(title: "Player Information", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Start Game!", style: .default) { (alertAction) in
            
            // What will happend once the user clicks the 'Add' action button on the UIAlert
            if nameTextField.text != "" && moneyTextField.text != "" {
            
                self.player.name = nameTextField.text!
                self.player.moneyAmount = Int(moneyTextField.text!)!
            }
            self.playerLabel.text = self.player.name
            self.updatePlayerMoneyTextField()
            self.generateBetAlert()
        }
        
        // adding a text field input to the alert
        alert.addTextField { (nameAlertTextField) in
            
            nameAlertTextField.placeholder = "Enter your name"
            // A reference to the textField variable created previouuly
            nameTextField = nameAlertTextField
            
        }
        
        alert.addTextField { (moneyAlertTextField) in
            
            moneyAlertTextField.placeholder = "Enter initial amount of money"
            moneyTextField = moneyAlertTextField
        }
        
        // Adding the action to the alert
        alert.addAction(action)
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    func generateBetAlert() {
        
        var betTextField = UITextField()
        
        // recomended bet 100% of your initial bet
        if player.betBox > 0 {
            betTextField.text = String(player.betBox * 2)
        } else {
            betTextField.text = "0"
        }
        
        let alert = UIAlertController(title: "Pease make a bet", message: "", preferredStyle: .alert)
        
        let betAction = UIAlertAction(title: "Place Bet!", style: .default) { (alertAction) in
            
            // What will happend once the user clicks the 'Place Bet!' action button on the UIAlert
            if betTextField.text != "" {
                
                let bet = Int(betTextField.text!)!
                
                if self.player.moneyAmount >= bet {
                    
                    self.player.substractMoney(amount: bet)
                    self.updatePlayerMoneyTextField()
                    
                    self.player.betBox += bet
                    self.updateBetBoxTextField(amount: self.player.betBox)
                    
                    // distribute cards
                    self.handleGameBeforeActions()
                    
                } else {
                    //TODO: Show error on the alert
                    print("You do not have enough founds.")
                }
            } else {
                //TODO: Show error on the alert
                print("Please provide a value.")
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
    
    func generateHandOverAlert(state: Bool) {
        var title = "Congratulation!!! you won."
        
        if state { title = "Oops Bad Luck. You lose." }
        
        let alert = UIAlertController(title: "\(title) Another Hand?", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            self.cleanUI()
            self.generateBetAlert()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
            
            //TODO: Close Game and save player values like name and amount of money
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Update UI infromation
    func updateBetBoxTextField(amount: Int) {
        betBoxLabel.text = "Bet box: $\(amount)"
    }
    
    func updatePlayerMoneyTextField() {
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
        deck = hand.generateDeck()
        updateBetBoxTextField(amount: 0)
        reloadCollectionViewData()
    }
    
}

