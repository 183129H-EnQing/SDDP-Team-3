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
        static let testTableName = "testSchedules"
        
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
            db.collection(tableName).document(userId).getDocument { (userSnapshost, err) in
                var schedules: [Int: [Schedule]] = [:]
                
                // using DispatchGroup: https://stackoverflow.com/a/35906703
                // Why? Because the onComplete runs after the last print statement for "index: n", so need to delay it
                let dispatchGrp = DispatchGroup()
                
                if let err = err {
                    print("Error getting schedules: \(err)")
                } else if let userDoc = userSnapshost, userDoc.exists { // if it exists, can run the rest
                    // after getting user document, need to find all existing days collection, so loop
                    // through the days array to give the index for day, which is the id
                    for index in 0..<SchedulerDetailsViewController.days.count {
                        print("index: \(index)")
                        // since after the above print statement, the onComplete will be done, so, we enter dispatchGroup here
                        dispatchGrp.enter()
                        
                        // pass in index to the collection to retrieve a day collection
                        userDoc.reference.collection("\(index)").getDocuments { (daysSnapshot, err) in
                            print("start of dayCollection")
                            
                            if let err = err {
                                print("Error getting days inside \(userId): \(err)")
                            } else if let daysDoc = daysSnapshot, daysDoc.count > 0 { // if count > 0, means for this specific day, there is data
                                print("Success for day \(index) with count \(daysDoc.count)")
                                
                                schedules[index] = [] // set an empty array for this day, inside schedules variable
                                daysDoc.documents.forEach { (daySnapshot) in // loop through the documents from daysDoc
                                    print("adding day")
                                    
                                    let data = daySnapshot.data()
                                    
                                    let exerciseName: String = data["exerciseName"] as! String
                                    let duration: [Int] = data["duration"] as! [Int]
                                    let time: [Int] = data["time"] as! [Int]
                                    
                                    let schedule = Schedule(exerciseName: exerciseName, duration: duration, day: index, time: time)
                                    schedule.id = daySnapshot.documentID
                                    schedules[index]?.append(schedule)
                                }
                            } else {
                                print("Collection day \(index) has no data")
                            }
                            print("end of dayCollection")
                            
                            // the print statement above will print after everything is done, so can be sure schedules got data, so we leave the dispatchGrp
                            dispatchGrp.leave()
                        }
                    }
                } else {
                    print("Schedules for \(userId) does not exist!")
                }
                
                dispatchGrp.notify(queue: .main) {
                    onComplete?(schedules)
                }
            }
        }
        
        static func insertSchedules(user: User, _ schedule: Schedule, onComplete: (((_:Bool) -> Void))?) {
            /* to break down,
             1. I'm getting the collection first, named "schedules"
             2. Then I'm getting a document with the id as user's id
             3. When retrieved the document, need to check if it exists or not, if no document with userId,
             need to create document, so userDocRef.setData
             4. After checking user document's existence, we will get the schedule's specified day, using this
             integer as key to get the day collection
             5. Inside a day collection, I do document(), this is to generate a new document with auto-generated id.
             6. ref.setData is to set the fields inside document.
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
                    if let _ = err {
                        onComplete?(false)
                    } else {
                        onComplete?(true)
                    }
                }
            }
        }
        
        static func loadSchedule_NoSubCollection(userId: String, onComplete: (([Int: [Schedule]]) -> Void)?) {
            db.collection(testTableName).getDocuments { (snapshot, err) in
                var schedules: [Int: [Schedule]] = [:]
                if let err = err {
                    print("Error for \(testTableName): \(err)")
                } else if let snapshot = snapshot, snapshot.count > 0 {
                    print("Got data: \(snapshot.count)")
                    for document in snapshot.documents {
                        print("Retrieving a document")
                        let data = document.data()
                        if userId.elementsEqual(data["creatorId"] as! String) {
                            print("Document's creator matched")
                            let day: Int = data["day"] as! Int
                            
                            if !schedules.keys.contains(day) {
                                schedules[day] = []
                            }
                            
                            let exerciseName: String = data["exerciseName"] as! String
                            let duration: [Int] = data["duration"] as! [Int]
                            let time: [Int] = data["time"] as! [Int]
                            
                            let schedule = Schedule(exerciseName: exerciseName, duration: duration, day: day, time: time)
                            schedule.id = document.documentID
                            schedules[day]!.append(schedule)
                            
                            schedules[day]!.sort(by: { (aSchedule, bSchedule) -> Bool in
                                let aHour = aSchedule.time[0]
                                let bHour = bSchedule.time[0]
                                return aHour < bHour || (aHour == bHour && aSchedule.time[1] < bSchedule.time[1])
                            })
                        }
                    }
                } else {
                    print("No data for \(testTableName)")
                }
                
                onComplete?(schedules)
            }
        }
        
        static func insertSchedule_NoSubCollection(userId: String, _ schedule: Schedule, onComplete: (((_ isSuccess:Bool) -> Void))?) {
            db.collection(testTableName).addDocument(data: [
                "creatorId": userId,
                "exerciseName": schedule.exerciseName,
                "duration": schedule.duration,
                "day": schedule.day,
                "time": schedule.time
            ]) { err in
                if let _ = err {
                    onComplete?(false)
                } else {
                    onComplete?(true)
                }
            }
        }
        
        static func updateSchedule_NoSubCollection(schedule: Schedule, onComplete: ((_ isSuccess:Bool)-> Void)?) {
            db.collection(testTableName).document(schedule.id!).updateData([
                "exerciseName": schedule.exerciseName,
                "duration": schedule.duration,
                "day": schedule.day,
                "time": schedule.time
            ]) { (err) in
                if let _ = err {
                    onComplete?(false)
                } else {
                    onComplete?(true)
                }
            }
        }
    }
}
