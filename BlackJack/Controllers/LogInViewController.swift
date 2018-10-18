//
//  LogInViewController.swift
//  BlackJack
//
//  Created by Testing on 10/14/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD

class LogInViewController : UIViewController {
    
    let util: Reusables = Reusables()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = "yero@gmail.com"
        passwordTextField.text = "qwerty"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        
        // Show the progress bar
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
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
                print("Log in successfull!")
                
                // sent user to chat View
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToGames", sender: self)
            }
        }
    }
}
