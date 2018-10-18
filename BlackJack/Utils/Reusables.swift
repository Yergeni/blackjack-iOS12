//
//  Reusables.swift
//  BlackJack
//
//  Created by Testing on 10/14/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Reusables {
    
    let db = Firestore.firestore()
//    var docData : [String : Any] = [:]
//    var docID : String = "Algo"
    
    init() {

    }
    
    //MARK: - Generic alerts
    func genericAlert(title: String, message: String, titleAction: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let Action = UIAlertAction(title: titleAction, style: .default) { (alertAction) in

        }
        
        alert.addAction(Action)
        
        return alert
    }
    
    
//    func getPlayerDocumentInfoByQuery() {
//
////        var docData : [String : Any] = [:]
//
//        if let user = Auth.auth().currentUser {
//            // [START simple_queries]
//            // Create a reference to the players collection
//            let playerRef = db.collection("players")
//
//            // Create a query against the collection.
//            let query = playerRef.whereField("email", isEqualTo: user.email!)
//            // [END simple_queries]
//            query.getDocuments(completion: { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//
//                        self.docID = self.getDocumentID(documentID: document.documentID)
//                        self.docData = self.getDocumentData(documentData: document.data())
//                    }
//                }
//            })
//        }
//    }
//
//
//    func getDocumentID(documentID: String) -> String {
//        return documentID
//    }
//
//    func getDocumentData(documentData: [String : Any]) -> [String : Any] {
//        return documentData
//    }
}
