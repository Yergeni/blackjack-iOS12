//
//  GameTableViewController.swift
//  BlackJack
//
//  Created by Testing on 10/14/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit
import Firebase

class GameTableViewController: UITableViewController {
    
    let games = Game().games
    let db = Firestore.firestore()
    let util = Reusables()
    var player : Player = Player()
    var docID = "algo"

    @IBOutlet var gameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFireBasePlayerInformation()
        
        // nibName is the name of the xib file (GameTableViewCell.xib)
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        
        tableView.rowHeight = 80.0
        
        // Not show lines on the table
        gameTableView.separatorStyle = .none
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        
        cell.imageView?.image = UIImage(named: "bj-bicolor-logo")
        cell.gameTitle.text = games[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Update player game attribute
        updatePlayerGame(documentID: docID, currentGame: games[indexPath.row])
        performSegue(withIdentifier: "goToBlackjack", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! BlackjackViewController
        destinationVC.player = self.player
        destinationVC.documentID = self.docID
    }
    
    
    //MARK: - Log Out
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch  {
            //TODO: Show an alert if with error
            print("error, there was a problem signing out.")
        }
    }
    
    
    //MARK: - Firebase methods
    private func getFireBasePlayerInformation() {

        if let user = Auth.auth().currentUser {
            // [START simple_queries]
            // Create a reference to the players collection
            let playerRef = db.collection("players")

            // Create a query against the collection.
            let query = playerRef.whereField("email", isEqualTo: user.email!)

            // [END simple_queries]
            query.getDocuments(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.getDocumentID(doc: document.documentID)
                        self.generatePlayerInformation(nick: document.data()["nickname"] as! String,
                                                       money: document.data()["money"] as! Int)
                    }
                }
            })
        }
    }

    private func getDocumentID(doc: String) {
        self.docID = doc
    }

    private func updatePlayerGame(documentID: String, currentGame: String) {
        // [START update_document]
        let playerRef = db.collection("players").document(documentID)

        // Set the "game" field of the player
        playerRef.updateData([
            "game": currentGame
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        // [END update_document]
    }
    
    private func generatePlayerInformation(nick: String, money: Int) {
        player.moneyAmount = money
        player.nickname = nick
    }
    
}
