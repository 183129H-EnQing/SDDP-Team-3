//
//  TrainingPlan.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 6/22/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation

class TrainingPlan: NSObject {
    
    var tpName: String
    var tpDesc: String
    var tpReps : Int
    var tpExercises: [String]
    var tpImage: String
    
    
    
    init(tpName: String, tpDesc: String, tpReps: Int, tpExercises: [String], tpImage: String){
        self.tpName = tpName
        self.tpDesc = tpDesc
        self.tpReps = tpReps
        self.tpExercises = tpExercises
        self.tpImage = tpImage
    }
}
