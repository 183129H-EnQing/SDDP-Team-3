//
//  Schedule.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation

class Schedule {
    var id: String?; // come from Firebase's auto generate id for documents
    var exerciseId: Int;
    var duration: [Int]; // hour, minute
    var day: Int; // Commment: 0 to 6, Monday to Sunday
    var time: [Int]; // hour:minute, will be in 24hr-style
    
    init(exerciseId: Int, duration: [Int], day: Int, time: [Int]) {
        self.exerciseId = exerciseId;
        self.duration = duration;
        self.day = day;
        self.time = time;
    }
}
