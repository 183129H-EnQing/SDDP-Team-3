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
 
    static let endOfTheDayTime = "23:59"
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
                //addStepsToHealthKit(steps: 6000)
                 group.leave()
            }
          
   
        }
        
        group.enter()
        queue.async {
              getTodayCaloriesBurnt(){
                            (calories) in
                  todayCalories = calories
                 group.leave()
                        }
      
        }
        
        
        group.enter()
        queue.async{
            if let user = UserAuthentication.getLoggedInUser() {
                    
                DataManager.HealthKitActivities.loadHealthKitActivity(userId: user.uid ) { (data) in
                    print("loading data")
                                  if data.count > 0 {
                                      self.healthKitDataArray = data
                                      print(type(of: healthKitDataArray))
                                      insertOrUpdateHealthKitData(healthKitData:data)
                                  }
                         group.leave()
                              }
                  }
       
        }
        
        group.notify(queue: queue) {
            print("All tasks done")
        }

        
    }
    
    static func insertOrUpdateHealthKitData(healthKitData:[HealthKitActivity]) {
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
                    // Check date exists or not in the dateArray, exist don't append else append
                    // Does Not exist insert the data, if exists next step
                    // Check current date and time not over 1159 of the exist date so we can update the data
                    // Important: For now not checking the time and date for performance
                    for healthKitData in healthKitDataArray {
                        // not exists in the date array then we add the date ,to prevent dulicpate date inserting to db
                        print(healthKitData.dateSaved)
                        print("healthkitdataarry:",healthKitDateData)
                        if !healthKitDateData.contains(healthKitData.dateSaved) {
                             healthKitDateData.append(healthKitData.dateSaved)
                                // insert the whole new data
                                    let newHealthKitActivity = HealthKitActivity(todayStep: todaySteps, todayCaloriesBurnt: todayCalories, timeSaved: todayTime , dateSaved: todayDateString)
             
                                    DataManager.HealthKitActivities.insertHealthKitActivity(userId: user!.uid, newHealthKitActivity){ (isSuccess) in
                                      print("insert")
                                    }
                        }
                        else{
                          let healthKitActivityId = healthKitData.healthKitActivityId!
                                                
                          let newHealthKitActivity = HealthKitActivity(todayStep: todaySteps, todayCaloriesBurnt: todayCalories, timeSaved: todayTime , dateSaved: todayDateString)
                            
                            DataManager.HealthKitActivities.updateHealthKitData(healthKitActivityId: healthKitActivityId,healthKitActivityData:newHealthKitActivity){ (isSuccess) in
                             print("update")
                           }
                        }
                    
                        
                        
                
                    }
                    // need to check whether over 1159 of the current date or not
                    // if got data already update else insert
                    
        //            for healthKitData in healthKitDataArray{
        //                if healthKitDateData.contains(healthKitData.dateSaved){
        //                    print("date exists",healthKitData.dateSaved)
        //                    //update
        //                }else{
                           // print("date does not exist")
                       
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
    
    
    static func addStepsToHealthKit(steps : Double) {

      // 1.set the type of data we want to insert into healthkit
      // 2. add in the amount and unit you want to the healthkit
      let quantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
      
      let quanitytUnit = HKUnit(from: "count")
      let quantityAmount = HKQuantity(unit: quanitytUnit, doubleValue: steps)
      let now = Date()

      let sample = HKQuantitySample(type: quantityType, quantity: quantityAmount, start: now, end: now)
      let correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)

      let waterCorrelationForWaterAmount = HKCorrelation(type: correlationType!, start: now, end: now, objects: [sample])
     
     
      self.healthStore.save(waterCorrelationForWaterAmount, withCompletion: { (success, error) in
        if (error != nil) {
          print("got error saving data into healthkit")
        }
      })
    }
    // Write data into Healthkit
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
