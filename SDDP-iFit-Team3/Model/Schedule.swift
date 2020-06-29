//
//  Schedule.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation

class Schedule {
    var id: String?;
    var name: String;
    var duration: [Int]; // hour, minute
    var day: Int; // Commment: 0 to 6, Monday to Sunday
    var time: [Int]; // hour:minute, will be in 24hr-style
    
    init(exerciseName: String, duration: [Int], day: Int, time: [Int]) {
        self.name = exerciseName;
        self.duration = duration;
        self.day = day;
        self.time = time;
    }
}
