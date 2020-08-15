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

    private static let userTableName = "users"
    
    static func getUserData(userId: String, onComplete: ((User?) -> Void)?) {
        db.collection(userTableName).document(userId).getDocument { (document, err) in
            var user: User?
            if let err = err {
                print("error getting user data: \(err)")
            } else if let document = document {
                let email = document.get("email") as! String
                let username = document.get("username") as! String
                
                user = User(userId: userId, email: email)
                user!.username = username
                
                if let avatarUrl = document.get("avatarURL") as? String {
                    user!.avatarURL = URL(string: avatarUrl)
                }
                
                if let fitnessInfo = document.get("fitnessInfo") as? [String:Float] {
                    print(fitnessInfo)
                    let weight = fitnessInfo["weight"]!
                    let height = fitnessInfo["height"]!
                    
                    user?.fitnessInfo = FitnessInfo(weight: weight, height: height)
                }
            } else {
                print("user has no data")
            }
            
            onComplete?(user)
        }
    }
    
    static func addUser(userId: String, username: String, email: String) {
        db.collection(userTableName).document(userId).setData([
            "username": username,
            "email": email
        ]) { err in
            if let err = err {
                print("Error adding username: \(err)")
            } else {
                print("Username '\(username)' successfully added")
            }
        }
    }
    
    static func updateUser(userId: String, userData: [String:Any]) {
        db.collection(userTableName).document(userId).updateData(userData) { err in
            if let err = err {
                print("Error updating user: \(err)")
            } else {
                print("User \(userId) successfully updated their user!")
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
                        let data = document.data()
                        if userId.elementsEqual(data["creatorId"] as! String) {
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
        
        static func getSchedule(_ scheduleId: String, onComplete: ((Schedule?) -> Void)?) {
            db.collection(tableName).document(scheduleId).getDocument { (document, err) in
                var schedule: Schedule? = nil
                
                if let err = err {
                    print("error retrieving a schedule: \(err)")
                } else if let document = document {
                    let day: Int = document.get("day") as! Int
                    let exerciseId: Int = document.get("exerciseId") as! Int
                    let duration: [Int] = document.get("duration") as! [Int]
                    let time: [Int] = document.get("time") as! [Int]
                    
                    schedule = Schedule(exerciseId: exerciseId, duration: duration, day: day, time: time)
                    schedule!.id = document.documentID
                }
                
                onComplete?(schedule)
            }
        }
        
        static func insertSchedule(userId: String, _ schedule: Schedule, onComplete: ((_ isSuccess:Bool, String?) -> Void)?) {
            // addDocument will create a document, with Firebase handling the auto-generation of ID
            var ref: DocumentReference?
            ref = db.collection(tableName).addDocument(data: [
                "creatorId": userId,
                "exerciseId": schedule.exerciseId,
                "duration": schedule.duration,
                "day": schedule.day,
                "time": schedule.time
            ]) { err in
                if let _ = err {
                    onComplete?(false, nil)
                } else {
                    onComplete?(true, ref!.documentID)
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
        
        static func loadTrainingPlan(userId: String, onComplete: (([TrainingPlan]) -> Void)?) {
            db.collection(tableName).getDocuments() { (querySnapshot, err) in
                var trainingPlanList : [TrainingPlan] = []
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
                        print(document.data())
                        if document.data()["userId"] as! String == userId || document.data()["userId"] as! String == "default" {
                            let id = document.documentID
                            let userId = document.data()["userId"] as! String
                            let name = document.data()["name"] as! String
                            let desc = document.data()["desc"] as! String
                            let reps = document.data()["reps"] as! Int
                            let exerciseList = document.data()["exercises"] as! [String]
                            let image = document.data()["image"] as! String
                            
                            let tp = TrainingPlan(id: id, userId: userId, tpName: name, tpDesc: desc, tpReps: reps, tpExercises: exerciseList, tpImage: image)
                            if tp != nil {
                                trainingPlanList.append(tp) }
                        }
                    } }
                // Once we have completed processing, call the onCompletes
                // closure passed in by the caller.
                //
                onComplete?(trainingPlanList)
                
            }
        }
        
        static func insertTrainingPlan(_userId: String, trainingPlan: TrainingPlan, onComplete: ((_ isSuccess:Bool) -> Void)?) {
            
            
            db.collection(tableName).addDocument(data: [
                "userId": trainingPlan.userId,
                "name": trainingPlan.tpName,
                "desc": trainingPlan.tpDesc,
                "reps": trainingPlan.tpReps,
                "exercises": trainingPlan.tpExercises,
                "image": trainingPlan.tpImage
            ]) { err in
                if let _ = err {
                    onComplete?(false)
                    print("false")
                } else {
                    onComplete?(true)
                    print("true")
                }
            }
        }
        
        
        static func updateTrainingPlan(userId: String, trainingPlan: TrainingPlan, onComplete: ((_ isSuccess:Bool)-> Void)?) {
            db.collection(tableName).document(trainingPlan.id).updateData([
                "userId": trainingPlan.userId,
                "name": trainingPlan.tpName,
                "desc": trainingPlan.tpDesc,
                "reps": trainingPlan.tpReps,
                "exercises": trainingPlan.tpExercises,
                "image": trainingPlan.tpImage
            ]) { err in
                if let _ = err {
                    onComplete?(false)
//                    print("false")
                } else {
                    onComplete?(true)
//                    print("true")
                }
            }
        }
        
        static func deleteTrainingPlan(userId: String, trainingPlan: TrainingPlan, onComplete: ((_ isSuccess:Bool)-> Void)?) {
            db.collection(tableName).document(trainingPlan.id).delete { (err) in
                if let err = err {
                    print("Error deleting trainingPlan: \(err)")
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
    
    class GamesClass {
        static let tableName = "game"
        
        static func loadGame(userId: String, onComplete: ((Game?) -> Void)?) {
            db.collection(tableName).document(userId).getDocument { (document, err) in
                var gameItem : Game? = nil
                
                if let err = err
                { // Handle errors here.
                    //
                    print("Error getting documents: \(err)")
                }
                else if let document = document
                {
                    let armyCount = document.get("armyCount") as! Int
                    let planets = document.get("planets") as! Int
                    
                    gameItem = Game(armyCount: armyCount, planets: planets, userId: userId)
                }
                // Once we have completed processing, call the onCompletes
                // closure passed in by the caller.
                onComplete?(gameItem)
            }
        }
        
        static func insertGame(_ userId: String) {
            db.collection(tableName).document(userId).setData([
                "armyCount": 5,
                "planets": 1
            ]) { err in
                if let _ = err {
//                    print("false")
                } else {
//                    print("true")
                }
            }
        }
        
        static func updateGame(userId: String, game: Game, onComplete: ((_ isSuccess:Bool)-> Void)?) {
            db.collection(tableName).document(userId).updateData([
                "armyCount": game.armyCount,
                "planets": game.planets
            ]) { err in
                if let _ = err {
                    onComplete?(false)
                    //                    print("false")
                } else {
                    onComplete?(true)
                    //                    print("true")
                }
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
                         "processPercent": goal.progressPercent,
                         "status": goal.status
                            
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
                      // var count = 0
                      if let err = err {
                          print("Error for \(tableName): \(err)")
                      } else if let snapshot = snapshot, snapshot.count > 0 {
                          
                          //print("Got data: \(snapshot.count)")
                          for document in snapshot.documents {
                             // print("Retrieving a document")
                              let data = document.data()
                              if userId.elementsEqual(data["userId"] as! String) {
                                //  print("Document's creator matched")
      
                                let goalTitle : String = data["goalTitle"] as! String
                                let activityName : String = data["activityName"] as! String
                                let date : String = data["date"] as! String
                                let duration : Int = data["duration"] as! Int
                                let processPercent : Double = data["processPercent"] as! Double
                                let totalExerciseAmount : Int = data["totalExerciseAmount"] as! Int
                                let status : String = data["status"] as! String
                                let goal = Goal(goalTitle: goalTitle, activityName: activityName, date: date, duration: duration, progressPercent: processPercent, totalExerciseAmount: totalExerciseAmount,status: status)
                                
                                goal.goalId = document.documentID
                                if status == "onGoing" {
                                    goals.append(goal)
                                }
                               print(activityName,status)
                             
                              }
                          }
                      } else {
                          print("No data for \(tableName)")
                      }
                      
                      onComplete?(goals)
                  }
              }
        
        static func updateGoalStatus(status:String, goalId:String, onComplete: ((_ isSuccess:Bool)-> Void)?) {
                       // updateData will update the specified document for the schedule.id passed in, it will only overwrite the
                       // specified fields inside the document.
            db.collection(tableName).document(goalId).updateData([
                         "status": status
                       ]) { (err) in
                           if let err = err {
                               print("Error updating goal status: \(err)")
                               onComplete?(false)
                           } else {
                               onComplete?(true)
                           }
                       }
                   }
        static func updateGoalProcessPercent(processPercent: Double, goalId:String, onComplete: ((_ isSuccess:Bool)-> Void)?) {
                       // updateData will update the specified document for the schedule.id passed in, it will only overwrite the
                       // specified fields inside the document.
            db.collection(tableName).document(goalId).updateData([
                         "processPercent": processPercent
                       ]) { (err) in
                           if let err = err {
                               print("Error updating goal status: \(err)")
                               onComplete?(false)
                           } else {
                               onComplete?(true)
                           }
                       }
                   }
        
    }
    
    class HealthKitActivities{
           static let tableName = "healthKitActivity"
    
           static func insertHealthKitActivity(userId: String, _ healthKitActivity: HealthKitActivity, onComplete: (((_ isSuccess:Bool) -> Void))?) {
                        db.collection(tableName).addDocument(data: [
                            "userId": userId,
                            "todayStep": healthKitActivity.todayStep,
                            "todayCaloriesBurnt": healthKitActivity.todayCaloriesBurnt,
                            "dateSaved": healthKitActivity.dateSaved,
                            "timeSaved": healthKitActivity.timeSaved,
                            "hasUpdatedForYtd" : healthKitActivity.hasUpdatedForYtd
                        ]) { err in
                            if let _ = err {
                                onComplete?(false)
                            } else {
                                onComplete?(true)
                            }
                        }
                    }
        
        static func loadHealthKitActivity(userId: String, onComplete: (([HealthKitActivity]) -> Void)?) {
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
                          var healthKitActivities: [HealthKitActivity] = []
                          // var count = 0
                          if let err = err {
                              print("Error for \(tableName): \(err)")
                          } else if let snapshot = snapshot, snapshot.count > 0 {
                              
                             // print("Got data: \(snapshot.count)")
                              for document in snapshot.documents {
                                //  print("Retrieving a document")
                                  let data = document.data()
                                  if userId.elementsEqual(data["userId"] as! String) {
                                    //  print("Document's creator matched")
          
                                    let todayStep : Double = data["todayStep"] as! Double
                                    let todayCaloriesBurnt : Double = data["todayCaloriesBurnt"] as! Double
                                    let dateSaved : String = data["dateSaved"] as! String
                                    let timeSaved : String = data["timeSaved"] as! String
                                    let hasUpdatedForYtd : Bool = data["hasUpdatedForYtd"] as! Bool
                                    
                                    let healthKitActivity = HealthKitActivity(todayStep: todayStep, todayCaloriesBurnt: todayCaloriesBurnt, timeSaved: timeSaved, dateSaved: dateSaved,hasUpdatedForYtd: hasUpdatedForYtd)
                                    
                                    healthKitActivity.healthKitActivityId = document.documentID
                              
                                        healthKitActivities.append(healthKitActivity)
                            
                                  }
                              }
                          } else {
                              print("No data for \(tableName)")
                          }
                          
                          onComplete?(healthKitActivities)
                      }
                  }

        static func updateHealthKitData(healthKitActivityId: String ,healthKitActivityData: HealthKitActivity,  onComplete: ((_ isSuccess:Bool)-> Void)?) {
              
            db.collection(tableName).document(healthKitActivityId).updateData([
                                    "todayStep": healthKitActivityData.todayStep,
                                    "todayCaloriesBurnt": healthKitActivityData.todayCaloriesBurnt,
                                    "timeSaved": healthKitActivityData.timeSaved,
                                    "hasUpdatedForYtd": healthKitActivityData.hasUpdatedForYtd
                             ]) { (err) in
                                 if let err = err {
                                     print("Error updating goal status: \(err)")
                                     onComplete?(false)
                                 } else {
                                     onComplete?(true)
                                 }
                             }
                         }
    }
    
    class Posts {
        static let tableName = "posts"
        
        static func insertPost(userId: String, _ post: Post, onComplete: (((_ isSuccess:Bool) -> Void))?) {
                     db.collection(tableName).addDocument(data: [
                         "userId": userId,
                         "pcontent": post.pcontent,
                         "pdatetime": post.pdatetime,
                         "userLocation": post.userLocation,
                         "pimageName": post.pimageName,
                         "opened"      : post.opened,
                         "profileImg"  : post.profileImg,
                         "commentPost": post.commentPost
                            
                     ]) { err in
                         if let _ = err {
                             onComplete?(false)
                         } else {
                             onComplete?(true)
                         }
                     }
                 }
        
          static func updatePost(post: Post, onComplete: ((_ isSuccess:Bool)-> Void)?) {
                  // updateData will update the specified document for the schedule.id passed in, it will only overwrite the
                  // specified fields inside the document.
                  db.collection(tableName).document(post.id!).updateData([
                      "userName": post.userId,
                      "pcontent": post.pcontent,
                      "pdatetime": post.pdatetime,
                      "userLocation": post.userLocation,
                      "pimageName": post.pimageName,
                      "opened"    : post.opened,
                      "commentPost":post.commentPost
                    
                  ]) { (err) in
                      if let err = err {
                          print("Error updating post: \(err)")
                          onComplete?(false)
                      } else {
                          onComplete?(true)
                      }
                  }
              }
        
        
        static func deletePost(post: Post,  onComplete: ((_ isSuccess:Bool)-> Void)?) {
           
                db.collection(tableName).document(post.id!).delete { (err) in
                  
                    if let err = err {
                    print("Error deleting post: \(err)")
                    onComplete?(false)
                } else {
                    onComplete?(true)
                }
            
            }
            
            
        }
        
        static func insertComment(userId: String, postId: String, _ comments: [Comment], onComplete: (((_ isSuccess:Bool) -> Void))?) {
            // json encode for raw Comment object https://stackoverflow.com/a/55069484
            var list_comment = [Any]()
           
     
            for item in comments {
                do {
                    let jsonData = try JSONEncoder().encode(item)
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                    list_comment.append(jsonObject)
                }
                catch {
                    // handle error
                }
            }
            db.collection(tableName).document(postId).updateData([
                               "commentPost": list_comment
                           ]) { err in
                               if let _ = err {
                                   onComplete?(false)
                               } else {
                                   onComplete?(true)
                               }
                           }
                       }
        static func loadPosts(userId: String, onComplete: (([Post]) -> Void)?) {
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
                            var posts: [Post] = []
                            if let err = err {
                                print("Error for \(tableName): \(err)")
                            } else if let snapshot = snapshot, snapshot.count > 0 {
                                print("Got data: \(snapshot.count)")
                                for document in snapshot.documents {
                                    print("Retrieving a document")
                                    let data = document.data()
                                    if userId.elementsEqual(data["userId"] as! String) {
                                        print("Document's creator matched")
                                      let userId : String = data["userId"] as! String
                                      let pcontent : String = data["pcontent"] as! String
                                      let pdatetime : String = data["pdatetime"] as! String
                                      let userLocation : String = data["userLocation"] as! String
                                      let pimageName : String = data["pimageName"] as! String
                                      let opened    :    Bool = data["opened"] as! Bool
                                      let profileImg : String = data["profileImg"] as! String
                                      
                                                             let comments: [[String:String]] = data["commentPost"] as! [[String:String]]
                                                             var commentPost : [Comment] = []
                                                             comments.forEach{ commentObj in
                                                                 let commentText = commentObj["comment"]!
                                                                 let pDateTime = commentObj["pdatetime"]!
                                                                 let commentOwnerId = commentObj["userId"]!
                                                                 
                                                                 commentPost.append(Comment(userId: commentOwnerId, comment: commentText, pdatetime: pDateTime))
                                                                 print("comment: \(commentObj)")
                                                             }

                                        let post = Post( userId: userId, pcontent: pcontent, pdatetime: pdatetime, userLocation: userLocation, pimageName: pimageName, opened: opened,profileImg: profileImg, commentPost: commentPost)
                                        
                                        
                                        post.id = document.documentID
                                        
                                      posts.append(post)
                                   
                                    }
                                }
                            } else {
                                print("No data for \(tableName)")
                            }
                            
                            onComplete?(posts)
                        }
                    }
        
        static func loadAllPosts(userId: String, onComplete: (([Post]) -> Void)?) {
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
                var posts: [Post] = []
                if let err = err {
                    print("Error for \(tableName): \(err)")
                } else if let snapshot = snapshot, snapshot.count > 0 {
                    print("Got data: \(snapshot.count)")
                    for document in snapshot.documents {
                        print("Retrieving a document")
                        let data = document.data()
                        //if userId.elementsEqual(data["userId"] as! String) {
                            print("Document's creator matched")
                          let userId : String = data["userId"] as! String
                          let pcontent : String = data["pcontent"] as! String
                          let pdatetime : String = data["pdatetime"] as! String
                          let userLocation : String = data["userLocation"] as! String
                          let pimageName : String = data["pimageName"] as! String
                          let opened    :    Bool = data["opened"] as! Bool
                        let profileImg : String = data ["profileImg"] as! String
                        
                        let comments: [[String:String]] = data["commentPost"] as! [[String:String]]
                        var commentPost : [Comment] = []
                        comments.forEach{ commentObj in
                            let commentText = commentObj["comment"]!
                            let pDateTime = commentObj["pdatetime"]!
                            let commentOwnerId = commentObj["userId"]!
                            
                            commentPost.append(Comment(userId: commentOwnerId, comment: commentText, pdatetime: pDateTime))
                            print("comment: \(commentObj)")
                        }

                        let post = Post(userId: userId, pcontent: pcontent, pdatetime: pdatetime, userLocation: userLocation, pimageName: pimageName, opened: opened,profileImg: profileImg,  commentPost: commentPost)
                            
                            
                            post.id = document.documentID
                            
                          posts.append(post)
                       
                       // }
                    }
                } else {
                    print("No data for \(tableName)")
                }
                
                onComplete?(posts)
            }
        }
        
         static func loadComments(userId: String, onComplete: (([Comment]) -> Void)?) {
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
                  
                      var commentPost : [Comment] = []
                    if let err = err {
                           print("Error for \(tableName): \(err)")
                       } else if let snapshot = snapshot, snapshot.count > 0 {
                           print("Got data: \(snapshot.count)")
                           for document in snapshot.documents {
                               print("Retrieving a document")
                           
                                let data = document.data()
                              let comments: [[String:String]] = data["commentPost"] as! [[String:String]]
                                                 
                                                  comments.forEach{ commentObj in
                                                      let commentText = commentObj["comment"]!
                                                      let pDateTime = commentObj["pdatetime"]!
                                                      let commentOwnerId = commentObj["userId"]!
                                                      
                                                      commentPost.append(Comment(userId: commentOwnerId, comment: commentText, pdatetime: pDateTime))
                                                      print("comment: \(commentObj)")
                                                  }
                                   
                                   //comment.id = document.documentID
                                   
                               
                              // }
                           }
                       } else {
                           print("No data for \(tableName)")
                       }
                       
                       onComplete?(commentPost)
                    
            }
               }
        
                  }
    
    
    
    
}
