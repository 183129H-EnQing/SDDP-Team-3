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
    @IBOutlet weak var squatDataLabel: UILabel!
 
    var healthKitActivityList : [HealthKitActivity] = []
    var todaySquat : Int = 0
    var todaySteps : Double = 0
    var todayCaloriesBurnt : Double = 0
    var todayRunningWalkingDistance : Double = 0
    let healthStore = HKHealthStore()
    let queue = DispatchQueue(label: "Serial queue")
    let group = DispatchGroup()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
        authorizeAndGetHealthKit()
    }
    
    func authorizeAndGetHealthKit() {

        HealthKitManager.authorizeHealthKit(){ (authorizeStatus) in
            print("hello",authorizeStatus!)
            let authoriseStatusValue = authorizeStatus!
            if (!authoriseStatusValue){
                self.presentHealthDataNotAvailableError()
            }else{
       
                  HealthKitManager.getHealthKitData(){
                        print("testing1")
                                          
                            }
                    sleep(1);
                DataManager.HealthKitActivities.loadHealthKitActivity(userId: UserAuthentication.user!.userId){
                            (data) in
                        if data.count > 0 {
                         print("pui pui pui pui")
                            //let calendar = Calendar.current
                         self.healthKitActivityList = data
                         self.displayData()

                         }

                     }
                    
                

            }
        }

    }
    func displayData(){
        let formatter = DateFormatter()
        formatter.timeZone  = TimeZone(identifier: "Asia/Singapore") // US_POSIX - usa , en_SG
        formatter.dateFormat = "dd MMM yyyy"
        let todayDateString = formatter.string(from: Date())
           //let todayDate = formatter.date(from: todayDateString)!
               //self.healthKitActivityList = data

        DispatchQueue.global(qos: .userInitiated).async {
               for activityData in self.healthKitActivityList{
                     print(todayDateString,activityData.dateSaved,"ggg")
                 if (activityData.dateSaved == todayDateString){
                     self.todaySquat = activityData.todaySquat
                     self.todaySteps = activityData.todayStep
                     self.todayCaloriesBurnt = activityData.todayCaloriesBurnt
                     self.todayRunningWalkingDistance = activityData.todayRunningWalkingDistance
         
                    print("\(activityData.todayStep) pui pui")
                }
            }
       DispatchQueue.main.async {
        print("testing squat\(self.todaySquat)")
            self.energyBurnDataLabel.text = "\(self.todayCaloriesBurnt)"
            self.stepsDataLabel.text = "\(self.todaySteps)"
            self.runningDataLabel.text = "\(self.todayRunningWalkingDistance)km"
            self.squatDataLabel.text = "\(self.todaySquat)"
            print("hello111111")
            // self.group.leave()
         
       }
           }
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
