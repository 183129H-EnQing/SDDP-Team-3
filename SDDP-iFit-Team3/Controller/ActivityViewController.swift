//
//  ActivityViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 29/6/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import HealthKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var heartRateDataLabel: UILabel!
    @IBOutlet weak var sleepDataLabel: UILabel!
    @IBOutlet weak var energyBurnDataLabel: UILabel!
    @IBOutlet weak var stepsDataLabel: UILabel!
    @IBOutlet weak var runningDataLabel: UILabel!
    @IBOutlet weak var cyclingDataLabel: UILabel!
    let healthStore = HKHealthStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        authorizeHealthKit()
    }
    
    @IBAction func authoriseKitClick(_ sender: Any) {
     authorizeHealthKit()
    }
    func getHealthKitData(){
        //1. Check to see if HealthKit Is Available on this device
      authorizeHealthKit()
    }
 
     // these data will be able to read/write
     let allTypes = Set([HKObjectType.workoutType(),
     HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
     HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
     HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
     HKObjectType.quantityType(forIdentifier: .heartRate)!,
     HKObjectType.quantityType(forIdentifier: .stepCount)!,
     HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
    ])
     
 
    // this function does not accept any parameters
    // return a boolean (fail or pass)
    // optional error if something goes wrong
    func authorizeHealthKit() {
    
        var totalSteps: Double = 0
        let queue = DispatchQueue(label: "update")
        // checking if healthstore is avaliable or not
        if !HKHealthStore.isHealthDataAvailable() {
            presentHealthDataNotAvailableError()
            print("healh data not avaliable")
            return
          }
        
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                self.presentHealthDataNotAvailableError()
                print("no permission or no healthstore")
            }else{
                print("permission accept")
               // call get data function

               queue.async {
                    self.getTodaysSteps() { (steps) in
                                totalSteps = steps
                            }
                   }

                   // UPDATE UI after all calculations have been done
                   DispatchQueue.main.async {
                    self.stepsDataLabel.text = "\(totalSteps)"
   
                   }
               }
               
                
             
                
                
            }
        }
        
    
    
    //https://stackoverflow.com/questions/36559581/healthkit-swift-getting-todays-steps/44111542
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        
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
    
    private func presentHealthDataNotAvailableError() {
          let title = "Health Data Unavailable"
          let message = "Aw, shucks! We are unable to access health data on this device. Make sure you are using device with HealthKit capabilities."
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let action = UIAlertAction(title: "Dismiss", style: .default)
          
          alertController.addAction(action)
          
          present(alertController, animated: true)
      }
    

    private let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    func importStepsHistory() {
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: now)!

        var interval = DateComponents()
        interval.day = 1

        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
        anchorComponents.hour = 0
        let anchorDate = Calendar.current.date(from: anchorComponents)!

        let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                            quantitySamplePredicate: nil,
                                            options: [.cumulativeSum],
                                            anchorDate: anchorDate,
                                            intervalComponents: interval)
        query.initialResultsHandler = { _, results, error in
           
            guard let results = results else {
                
                print("Error returned form resultHandler = \(String(describing: error?.localizedDescription))")
                return
        }

            results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count())
                    print("Amount of steps: \(steps), date: \(statistics.startDate)")
                }
            }
        }

        healthStore.execute(query)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func addWaterAmountToHealthKit(ounces : Double) {
      // 1
      let quantityType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)
      
      // string value represents US fluid
      // 2
        let quanitytUnit = HKUnit(from: "fl_oz_us")
      let quantityAmount = HKQuantity(unit: quanitytUnit, doubleValue: ounces)
      let now = Date()
      // 3
      let sample = HKQuantitySample(type: quantityType!, quantity: quantityAmount, start: now, end: now)
      let correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)
      // 4
      let waterCorrelationForWaterAmount = HKCorrelation(type: correlationType!, start: now, end: now, objects: [sample])
      // Send water intake data to healthStore…aka ‘Health’ app
      // 5
        self.healthStore.save(waterCorrelationForWaterAmount, withCompletion: { (success, error) in
        if (error != nil) {
            print("error occer")
        }
      })
    }
}
