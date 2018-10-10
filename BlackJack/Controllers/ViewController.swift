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
    

    let dealerCardImageArray = ["red_back", "QD", "4H"]
    let playerCardImageArray = ["10C", "AD", "9H", "KS", "AS", "3H", "JC"]
    
    @IBOutlet weak var dealerCollectionView: UICollectionView!
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var betBoxLabel: UILabel!
    @IBOutlet weak var playerMoneyLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hand = Hand()
        // generating the deck
        self.deck = hand.generateDeck()
        
        dealerCollectionView.delegate = self
        dealerCollectionView.dataSource = self
        
        playerCollectionView.delegate = self
        playerCollectionView.dataSource = self
        
        betBoxLabel.text = "Bet box: $\(self.player.betBox)"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        generatePlayerStartingAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Button actions
    @IBAction func hitButtonPressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func stayButtonPressed(_ sender: UIButton) {
    }
    
    
    
    @IBAction func doubleDownButtonPressed(_ sender: UIButton) {
    }
    
    
    //MARK: - Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == dealerCollectionView {
            return dealerCardImageArray.count
        } else {
            return playerCardImageArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // var cell: UICollectionViewCell
        
        if collectionView == self.dealerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealerCollectionCell", for: indexPath) as! DealerCardCollectionViewCell
            
            cell.cardImage.image = UIImage(named: dealerCardImageArray[indexPath.item])
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCollectionCell", for: indexPath) as! PlayerCardCollectionViewCell
            
            cell.cardImage.image = UIImage(named: playerCardImageArray[indexPath.item])
            return cell
        }
    }
    
    
    //MARK: Util functions
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
            self.playerMoneyLabel.text = "Money: $\(self.player.moneyAmount)"
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
    
}

