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
import FirebaseFirestore

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
                "scheduleID1": {
                    "duration": [0, 10],
                    "exerciseName": "Jumping Jacks",
                    "time": [10, 0]
                }
            }
         }
         */
        
        static func loadSchedules(userId: String, onComplete: (([Int: [Schedule]]) -> Void)?) {
            /* Process
             1. Get all documents
             2. Check for errors, check if there are data to retrieve
             3. loop through all the documents
             4. In each document, check if the creatorId is the same as the logged in user's id
             5. Create empty array if our schedules variable' day is empty
             6. Retrieve fields from document, as well as documentId from document
             7. Put the fields into instance of Schedule and append Schedule to day array inside schedules variable
             8. Then we sort the day array after appending
             */
            db.collection(tableName).getDocuments { (snapshot, err) in
                var schedules: [Int: [Schedule]] = [:]
                if let err = err {
                    print("Error for \(tableName): \(err)")
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
                            
                            let exerciseId: Int = data["exerciseId"] as! Int
                            let duration: [Int] = data["duration"] as! [Int]
                            let time: [Int] = data["time"] as! [Int]
                            
                            let schedule = Schedule(exerciseId: exerciseId, duration: duration, day: day, time: time)
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
                    print("No data for \(tableName)")
                }
                
                onComplete?(schedules)
            }
        }
        
        static func insertSchedule(userId: String, _ schedule: Schedule, onComplete: (((_ isSuccess:Bool) -> Void))?) {
            // addDocument will create a document, with Firebase handling the auto-generation of ID
            db.collection(tableName).addDocument(data: [
                "creatorId": userId,
                "exerciseId": schedule.exerciseId,
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
        
        static func updateSchedule(schedule: Schedule, onComplete: ((_ isSuccess:Bool)-> Void)?) {
            // updateData will update the specified document for the schedule.id passed in, it will only overwrite the
            // specified fields inside the document.
            db.collection(tableName).document(schedule.id!).updateData([
                "exerciseId": schedule.exerciseId,
                "duration": schedule.duration,
                "day": schedule.day,
                "time": schedule.time
            ]) { (err) in
                if let err = err {
                    print("Error updating schedule: \(err)")
                    onComplete?(false)
                } else {
                    onComplete?(true)
                }
            }
        }
        
        static func deleteSchedule(schedule: Schedule, onComplete: ((_ isSuccess:Bool)-> Void)?) {
            db.collection(tableName).document(schedule.id!).delete { (err) in
                if let err = err {
                    print("Error deleting schedule: \(err)")
                    onComplete?(false)
                } else {
                    onComplete?(true)
                }
            }
        }
    }
    
    class TrainingPlanClass {
        static let tableName = "trainingPlan"
        
        static func insertTrainingPlan(userId: String, _ trainingPlan: TrainingPlan, onComplete: (((_ isSuccess:Bool) -> Void))?) {
            db.collection(tableName).addDocument(data: [
                "userId": userId,
                "name": trainingPlan.tpName,
                "desc": trainingPlan.tpDesc,
                "reps": trainingPlan.tpReps,
                "exercises": trainingPlan.tpExercises,
                "image": trainingPlan.tpImage
            ]) { err in
                if let _ = err {
                    onComplete?(false)
                } else {
                    onComplete?(true)
                }
            }
        }
        
        
        static func updateTrainingPlan(trainingPlan: TrainingPlan, onComplete: ((_ isSuccess:Bool)-> Void)?) {
            db.collection(tableName).document(trainingPlan.id!).updateData([
                "name": trainingPlan.tpName,
                "desc": trainingPlan.tpDesc,
                "reps": trainingPlan.tpReps,
                "exercises": trainingPlan.tpExercises,
                "image": trainingPlan.tpImage
            ]) { err in
                if let _ = err {
                    onComplete?(false)
                } else {
                    onComplete?(true)
                }
            }
        }
    }
    
    class ExerciseClass: Codable {
        static let tableName = "exercise"
        
        static func loadExercises(onComplete: (([Exercise]) -> Void)?) {
            db.collection(tableName).getDocuments() { (querySnapshot, err) in
                var exerciseList : [Exercise] = []
                if let err = err
                { // Handle errors here.
                    //
                    print("Error getting documents: \(err)") }
                else
                {
                    for document in querySnapshot!.documents
                    {
                        // This line tells Firestore to retrieve all fields
                        // and update it into our Movie object automatically.
                        //
                        // This requires the Movie object to implement the
                        // Codable protocol.
                        //
                        let name = document.documentID
                        let desc = document.data()["desc"] as! String
                        let image = document.data()["image"] as! String
                        
                        let exercise = Exercise(exName: name, exDesc: desc, exImage: image)
                        if exercise != nil {
                            exerciseList.append(exercise) }
                    } }
                // Once we have completed processing, call the onCompletes
                // closure passed in by the caller.
                //
                onComplete?(exerciseList)
                
            }
        }
    }
    
    class Goals{
        static let tableName = "goals"
        
        static func insertGoal(userId: String, _ goal: Goal, onComplete: (((_ isSuccess:Bool) -> Void))?) {
                     db.collection(tableName).addDocument(data: [
                         "userId": userId,
                         "goalTitle": goal.goalTitle,
                         "activityName": goal.activityName,
                         "date": goal.date,
                         "duration": goal.duration,
                         "totalExerciseAmount": goal.totalExerciseAmount,
                         "processPercent": goal.progressPercent
                            
                     ]) { err in
                         if let _ = err {
                             onComplete?(false)
                         } else {
                             onComplete?(true)
                         }
                     }
                 }
        
        static func loadGoals(userId: String, onComplete: (([Goal]) -> Void)?) {
                  /* Process
                   1. Get all documents
                   2. Check for errors, check if there are data to retrieve
                   3. loop through all the documents
                   4. In each document, check if the creatorId is the same as the logged in user's id
                   5. Create empty array if our schedules variable' day is empty
                   6. Retrieve fields from document, as well as documentId from document
                   7. Put the fields into instance of Schedule and append Schedule to day array inside schedules variable
                   8. Then we sort the day array after appending
                   */
                  db.collection(tableName).getDocuments { (snapshot, err) in
                      var goals: [Goal] = []
                      if let err = err {
                          print("Error for \(tableName): \(err)")
                      } else if let snapshot = snapshot, snapshot.count > 0 {
                          print("Got data: \(snapshot.count)")
                          for document in snapshot.documents {
                              print("Retrieving a document")
                              let data = document.data()
                              if userId.elementsEqual(data["userId"] as! String) {
                                  print("Document's creator matched")

                                let goalTitle : String = data["goalTitle"] as! String
                                let activityName : String = data["activityName"] as! String
                                let date : String = data["date"] as! String
                                let duration : Int = data["duration"] as! Int
                                let processPercent : Int = data["processPercent"] as! Int
                                let totalExerciseAmount : Int = data["totalExerciseAmount"] as! Int

                                let goal = Goal(goalTitle: goalTitle, activityName: activityName, date: date, duration: duration, progressPercent: processPercent, totalExerciseAmount: totalExerciseAmount)
                                    
                                goals.append(goal)
                             
                              }
                          }
                      } else {
                          print("No data for \(tableName)")
                      }
                      
                      onComplete?(goals)
                  }
              }
        

    }
    
}
