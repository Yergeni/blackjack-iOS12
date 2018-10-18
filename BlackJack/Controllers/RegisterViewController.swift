//
//  RegisterViewController.swift
//  BlackJack
//
//  Created by Testing on 10/14/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    let util: Reusables = Reusables()
    let db = Firestore.firestore()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        //TODO: Set up a new user on the Firbase database
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            if error != nil {
                //TODO: Show alert with error
                print(error!)
                SVProgressHUD.dismiss()
                self.present(self.util.genericAlert(title: error!.localizedDescription,
                                                    message: "", titleAction: "Ok"), animated: true)
            }
            else {
                // success
                print("registration successfull!")
                
                // sent user to game View
                SVProgressHUD.dismiss()
                
                // Add a new document with a generated ID
                var ref: DocumentReference? = nil
                ref = self.db.collection("players").addDocument(data: [
                    "email": self.emailTextField.text!,
                    "nickname": self.nicknameTextField.text!,
                    "money": 100,
                    "game" : ""
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        
                        self.present(self.util.genericAlert(title: err.localizedDescription,
                                                                message: "", titleAction: "Ok"), animated: true)
                        
                    } else {
                        print(">>> Document added with ID: \(ref!.documentID)")
                        
                        self.performSegue(withIdentifier: "goToGames", sender: self)
                    }
                }
            }
        }
    }
}
