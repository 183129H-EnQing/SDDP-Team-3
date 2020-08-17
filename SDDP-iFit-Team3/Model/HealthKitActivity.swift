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
     var todaySquat : Int;
     var todayRunningWalkingDistance : Double;
     var timeSaved: String;
     var dateSaved : String;
     var userId: String?;
     var hasUpdatedForYtd : Bool = false;
    
    init(todayStep: Double, todayCaloriesBurnt: Double, todaySquat: Int,todayRunningWalkingDistance: Double,timeSaved: String, dateSaved: String,hasUpdatedForYtd: Bool) {
           self.todayStep = todayStep
           self.todayCaloriesBurnt = todayCaloriesBurnt
           self.todaySquat = todaySquat
           self.todayRunningWalkingDistance = todayRunningWalkingDistance
           self.timeSaved = timeSaved
           self.dateSaved = dateSaved
           self.hasUpdatedForYtd = hasUpdatedForYtd
       }
}
