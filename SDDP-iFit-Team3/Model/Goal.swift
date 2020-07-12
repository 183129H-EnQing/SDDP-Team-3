//
//  Goal.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 7/1/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class Goal: NSObject {
    var goalId: String?;
    var goalTitle: String;
    var activityName: String;
    var date : String;
    var duration: Int; // day
    var progressPercent:Int;
    var totalExerciseAmount: Int;    // A number for the user to reach their activity target, 50 push.
    var status: String;
    //  var pointsReward: Int;

    var userId: String?;
    init(goalTitle:String,activityName:String,date:String,duration:Int,progressPercent:Int,totalExerciseAmount:Int,status:String) {
        self.activityName = activityName;
        self.goalTitle = goalTitle;
        self.date = date;
        self.duration = duration;
        self.progressPercent = progressPercent;
        self.totalExerciseAmount = totalExerciseAmount;
        self.status = status;
    }
    
}
