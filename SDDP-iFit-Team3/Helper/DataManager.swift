//
//  DataManager.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/1/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation
import Firebase

class DataManager {
    static let db = Firestore.firestore()

    // User ID: User name
    static func loadUsernames(onComplete: (([String: String]) -> Void)?) {
        db.collection("usernames").getDocuments() { (querySnapshot, err) in
            var usernames: [String: String] = [:]
            
            if let err = err {
                print("Error getting usernames: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID): \(document.data())")
                }
            }
        }
    }
}
