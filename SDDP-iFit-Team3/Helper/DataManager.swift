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
        static let tableName = "schedules"
        
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
            print("uid passed: \(userId)")
            
            // we get the document with userId as the id
            db.collection(tableName).document(userId).getDocument { (snapshot, err) in
                var schedules: [Int: [Schedule]] = [:]
                
                if let err = err {
                    print("Error getting schedules: \(err)")
                } else if let document = snapshot, document.exists { // if it exists, can run the rest
                    for (index, _) in SchedulerDetailsViewController.days.enumerated() {
                        document.reference.collection("\(index)").getDocuments { (snapshot, err) in
                            if let err = err {
                                print("Error getting days inside \(userId): \(err)")
                            } else if let document = snapshot, document.count > 0 {
                                print("Success for day \(index) with count \(document.count)")
                            } else {
                                print("Collection day \(index) has no data")
                            }
                        }
                    }
                    //print("Data: \(document.reference.coll)")
                    //print("Data: \(document.documents.count)")
                } else {
                    print("Schedules for \(userId) does not exist!")
                }
                
                onComplete?(schedules)
            }
        }
        
        static func insertSchedules(user: User, _ schedule: Schedule, onComplete: @escaping (() -> Void)) {
            /* to break down,
             1. I'm getting the collection first, named "schedules"
             2. Then I'm getting a document with the id as user's id
             3. Inside the user document, will contain multiple collections for different DAYS
             4. Inside one collection, with the day as id, I do document(), this is to generate a new document
             with auto-generated id.
             5. ref.setData is to set the fields inside document.
             */
            
            // get data for uid
            let userDocRef = db.collection(tableName).document(user.uid)
                
            userDocRef.getDocument { (document, err) in
                if let err = err {
                    print("Error getting user '\(user.uid)' schedules: \(err)")
                }
                
                if let document = document, !document.exists {
                    print("Document does not exist")
                    userDocRef.setData([:]) { (err) in
                        if let err = err {
                            print("Failed to add user '\(user.uid)' in schedules: \(err)")
                        }
                    }
                }
                
                userDocRef.collection("\(schedule.day)").addDocument(data: [
                    "exerciseName": schedule.exerciseName,
                    "duration": schedule.duration,
                    "time": schedule.time
                ]) { err in
//                    if let err = err {
//                        onComplete(false)
//                    } else {
//                        onComplete(true)
//                    }
                    onComplete()
                }
                //onComplete()
                    /*print("user '\(user.uid)' schedules does not exist. Need to make!")
                    db.collection(tableName).document(user.uid).setData([:]) { (err) in
                        if let err = err {
                            print("Failed to add user '\(user.uid)' in schedules: \(err)")
                        } else {
                            print("Adding schedule.")
                            db.collection(tableName).document(user.uid).collection("\(schedule.day)")
                        }
                    }*/
            }
            /*let ref = db.collection(tableName).document(user.uid).collection("\(schedule.day)")
            
            ref.addDocument(data: [
                "exerciseName": schedule.exerciseName,
                "duration": schedule.duration,
                "time": schedule.time
            ])
            */
        }
    }
}
