//
//  Schedule.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation

class Schedule {
    var id: String; // come from Firebase's auto generate id for documents
    var exerciseName: String;
    var duration: [Int]; // hour, minute
    var day: Int; // Commment: 0 to 6, Monday to Sunday
    var time: [Int]; // hour:minute, will be in 24hr-style
    
    init(id: String, exerciseName: String, duration: [Int], day: Int, time: [Int]) {
        self.id = id
        self.exerciseName = exerciseName;
        self.duration = duration;
        self.day = day;
        self.time = time;
    }
}
