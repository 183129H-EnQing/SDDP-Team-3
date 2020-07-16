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
                  completion?(!success)
              }else{
                  
                  print("got permission")
                  completion?(success)
              }
          }
        
    }
 
    static let queue = DispatchQueue(label: "Serial queue")
    static let group = DispatchGroup()
    static var todaySteps:Double = 0
    // completion should be healthkit data class
    static func getHealthKitData(completion: (() -> Void)?){
        group.enter()
        queue.async {
            getTodaysSteps(){
                (steps) in
                 todaySteps = steps
                 group.leave()
            }
            print("Task 1 done")
            print("testing2",todaySteps)
      
        }
        print("tesing1",todaySteps)
    
    }
    
    
    
      //https://stackoverflow.com/questions/36559581/healthkit-swift-getting-todays-steps/44111542
      static func getTodaysSteps(completion: @escaping (Double) -> Void) {
          
          let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

          let now = Date()
          print("now:",now)
          let startOfDay = Calendar.current.startOfDay(for: now)
          print("startDay :" ,startOfDay)
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
              print(sum)
              print("hello",result)
          }

          healthStore.execute(query)
      }
    
    

}
