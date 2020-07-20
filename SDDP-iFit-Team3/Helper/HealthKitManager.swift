//
//  HealthKitManager.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 7/16/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation
import HealthKit
import Firebase

class HealthKitManager{
        
    static let healthStore = HKHealthStore()
   
    // these data will be able to read/write
    static var allTypes = Set([HKObjectType.workoutType(),
       HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
       HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
       HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
       HKObjectType.quantityType(forIdentifier: .heartRate)!,
       HKObjectType.quantityType(forIdentifier: .stepCount)!,
       HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
      ])

      // this function does not accept any parameters
      // return a boolean (fail or pass)
    static func authorizeHealthKit(completion: ((Bool?) -> Void)?){
        
        // checking if healthstore is avaliable or not
        if !HKHealthStore.isHealthDataAvailable() {

            print("healh data not avaliable")
            completion?(false)
          }
        else{
      
            requestAuthorization() { (requestStatus) in
                completion?(requestStatus)
            }
        }
                  
    }
   
    static func requestAuthorization(completion: ((Bool?) -> Void)?){
          healthStore.requestAuthorization(toShare: allTypes, read:allTypes) { (success, error) in
           if !success {
                  print("no permission or no healthstore")
                  print("\(success)")
                  // a cheat method to access healthkit just put true will do, will have to switch it back when
                  // we fix the healthkit capablility issues
                  completion?(success)
                  // completion?(!success) <<< no more play cheat
              }else{
                  
                  print("got permission")
                  completion?(success)
              }
          }
        
    }
 
    static let queue = DispatchQueue(label: "Serial queue")
    static let group = DispatchGroup()
    static var todaySteps:Double = 0
    static var todayCalories:Double = 0
    static var healthKitDataArray: [HealthKitActivity] = []
    static var healthKitDateData : [String] = []
    // completion should be healthkit data class
    static func getHealthKitData(completion: (() -> Void)?){
        group.enter()
        queue.async {
            getTodaysSteps(){
                (steps) in
                 todaySteps = steps
                 print("testing2",todaySteps)
                 group.leave()
            }
          
   
        }
        
        group.enter()
        queue.async {
              getTodayCaloriesBurnt(){
                            (calories) in
                  todayCalories = calories
                  print(todayCalories)
                 group.leave()
                        }
      
        }
        
        
        group.enter()
        queue.async{
            if let user = UserAuthentication.getLoggedInUser() {
                        print("User is logged in")
                    
                DataManager.HealthKitActivities.loadHealthKitActivity(userId: user.uid ) { (data) in
                    print("loading data")
                                  if data.count > 0 {
                                      self.healthKitDataArray = data
                                    //print(data.count)
                                 //   for healthKitData in healthKitDataArray {
                                
//                                        if !healthKitDateData.contains(healthKitData.dateSaved){
//                                             healthKitDateData.append(healthKitData.dateSaved)
//
//                                        }
                                      
                                   // }
                                    // print("date data",healthKitDateData)
                                    
                                  }
                                  
                    doSomeShitInsert()
                         group.leave()
                              }
                  }
       
        }
        
        group.notify(queue: queue) {
            print("All tasks done")
        }
//
//        group.enter()
//        queue.async {
//            sleep(2)
//            print("Task 2 done")
//            group.leave()
//        }
        
    }
    
    static func doSomeShitInsert() {
                 //   let calendar = Calendar.current
                    let user = UserAuthentication.getLoggedInUser()
                    let formatter = DateFormatter()
                    formatter.timeZone  = TimeZone(identifier: "Asia/Singapore") // set locale to reliable US_POSIX - usa , en_SG - sg
                    formatter.dateFormat = "dd MMM yyyy"
                    let todayDateString = formatter.string(from: Date())
                   // let todayDate = formatter.date(from: todayDateString)!

                    formatter.dateFormat = "hh:mm"
                    let todayTime = formatter.string(from: Date())  //
                    
                    print("todayTime:",todayTime)
                    print("todayDate:",todayDateString)
                
                    // need to check whether over 1159 of the current date or not
                    // if got data already update else insert
                    
        //            for healthKitData in healthKitDataArray{
        //                if healthKitDateData.contains(healthKitData.dateSaved){
        //                    print("date exists",healthKitData.dateSaved)
        //                    //update
        //                }else{
                           // print("date does not exist")
                            let newHealthKitActivity = HealthKitActivity(todayStep: todaySteps, todayCaloriesBurnt: todayCalories, timeSaved: todayTime , dateSaved: todayDateString)
                    print("after init")
                            DataManager.HealthKitActivities.insertHealthKitActivity(userId: user!.uid, newHealthKitActivity){ (isSuccess) in
                               print("insert")
                            }
        //                }
        //            }
    }
    
      //https://stackoverflow.com/questions/36559581/healthkit-swift-getting-todays-steps/44111542
      static func getTodaysSteps(completion: @escaping (Double) -> Void) {
          
          let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

          let now = Date()
          //print("now:",now)
          let startOfDay = Calendar.current.startOfDay(for: now)
          //print("startDay :" ,startOfDay)
          // predicate is to help fliter the data within a time range
          let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

          //HKStatisticsCollectionQuery is better suited to use when you want to retrieve data over a time span.
          // Use HKStatisticsQuery to just get the steps for a specific date.
          let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
             
              guard let result = result, let sum = result.sumQuantity() else {
                  completion(0.0)
                  return
              }
              
              completion(sum.doubleValue(for: HKUnit.count()))
          }

          healthStore.execute(query)
      }
    
    static func getTodayCaloriesBurnt(completion: @escaping (Double) -> Void){
        let caloriesBurnt = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let now = Date()
       // print("now:",now)
           let startOfDay = Calendar.current.startOfDay(for: now)
        //   print("startDay :" ,startOfDay)
           // predicate is to help fliter the data within a time range
           let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

           //HKStatisticsCollectionQuery is better suited to use when you want to retrieve data over a time span.
           // Use HKStatisticsQuery to just get the steps for a specific date.
           let query = HKStatisticsQuery(quantityType: caloriesBurnt, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
              
               guard let result = result, let sum = result.sumQuantity() else {
                   completion(0.0)
                   return
               }
               
            completion(sum.doubleValue(for: HKUnit.kilocalorie()))
           }

           healthStore.execute(query)
    }
    
//    static func getTodaySleepHour(completion: @escaping (Int) -> Void){
//        let sleepCategoryType = HKQuantityType.categoryType(forIdentifier: .sleepAnalysis)!
//           let now = Date()
//          // print("now:",now)
//              let startOfDay = Calendar.current.startOfDay(for: now)
//           //   print("startDay :" ,startOfDay)
//              // predicate is to help fliter the data within a time range
//              let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//              let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//              //HKStatisticsCollectionQuery is better suited to use when you want to retrieve data over a time span.
//              // Use HKStatisticsQuery to just get the steps for a specific date.
//        let query = HKSampleQuery(sampleType: sleepCategoryType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) in
//                    if let result = tmpResult {
//                       for item in result {
//                           if let sample = item as? HKCategorySample {
//                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
//                              print(value)
//                           }
//                       }
//                   }
//                    
//            completion(100)
//        }
             
              
  
              
//
//              healthStore.execute(query)
//       }

    
    
   
}
