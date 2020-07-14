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

    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getHealthKitData()
    }
    
    func getHealthKitData(){
        //1. Check to see if HealthKit Is Available on this device
        if HKHealthStore.isHealthDataAvailable() {
           authorizeHealthKit()
        }
        else{
            presentHealthDataNotAvailableError()
        }
    }
 
     let allTypes = Set([HKObjectType.workoutType(),
     HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
     HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
     HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
     HKObjectType.quantityType(forIdentifier: .heartRate)!])
     
 
    // this function does not accept any parameters
    // return a boolean (fail or pass)
    // optional error if something goes wrong
    func authorizeHealthKit() {
    
    healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
        if !success {
            self.presentHealthDataNotAvailableError()
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
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
