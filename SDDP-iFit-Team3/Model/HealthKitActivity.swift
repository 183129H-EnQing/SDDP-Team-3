//
//  HealthKitActivity.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 7/16/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class HealthKitActivity: NSObject {
    
     var healthKitActivityId: String?;
     var todayStep: Double;
     var todayCaloriesBurnt: Double;
     var timeSaved: String;
     var dateSaved : String;
     var userId: String?;
   
    init(todayStep: Double, todayCaloriesBurnt: Double, timeSaved: String, dateSaved: String) {
           self.todayStep = todayStep
           self.todayCaloriesBurnt = todayCaloriesBurnt
           self.timeSaved = timeSaved
           self.dateSaved = dateSaved
       }
}
