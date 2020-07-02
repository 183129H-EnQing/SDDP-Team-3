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
                    let userId = document.documentID
                    let username = document.data()["username"] as! String
                    
                    usernames[userId] = username
                }
            }
            
            onComplete?(usernames)
        }
    }
    
    static func addUsername(userId: String, username: String) {
        db.collection("usernames").document(userId).setData(["username": username]) { err in
            if let err = err {
                print("Error adding username: \(err)")
            } else {
                print("Username '\(username)' successfully added")
            }
        }
    }
    
    class Schedules {
        static func loadSchedules(userId: String, onComplete: (([Int: [Schedule]]) -> Void)?) {
            db.collection("schedules").document(userId).getDocument { (snapshot, err) in
                var schedules: [Int: [Schedule]] = [:]
                
                if let err = err {
                    print("Error getting schedules: \(err)")
                } else if let document = snapshot, document.exists {
                    print("Data: \(document.data())")
                } else {
                    print("Schedules for \(userId) does not exist!")
                }
                
                onComplete?(schedules)
            }
        }
    }
}
