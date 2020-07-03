//
//  DataManager.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/1/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

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
        /*
         {
            "schedules": {
                "userID1": {
                    "0": { // 0 is Monday.
                        "scheduleID1": {
                            "duration": [0, 10],
                            "exerciseName": "Jumping Jacks",
                            "time": [10, 0]
                        }
                    }
                }
            }
         }
         */
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
        
        static func insertSchedules(user: User, _ schedule: Schedule, onComplete: @escaping () -> Void) {
            /* to break down,
             1. I'm getting the collection first, named "schedules"
             2. Then I'm getting a document with the id as user's id
             3. Inside the user document, will contain multiple collections for different DAYS
             4. Inside one collection, with the day as id, I do document(), this is to generate a new document
             with auto-generated id.
             5. ref.setData is to set the fields inside document.
             */
            let ref = db.collection("schedules").document(user.uid).collection("\(schedule.day)").document()
            
            ref.setData([
                "exerciseName": schedule.exerciseName,
                "duration": schedule.duration,
                "time": schedule.time
            ])
            
            onComplete()
        }
    }
}
