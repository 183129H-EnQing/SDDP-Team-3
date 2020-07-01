//
//  Challenge.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 7/1/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class Challenge: NSObject {

    var challengeId: String?;
    var challengeName: String;
    var challengeDescription: String;
    var numberOfParticipants: Int;
    
    init(challengeName:String,challengeDescripiton:String,numberOfParticipants:Int){
        self.challengeName = challengeName;
        self.challengeDescription = challengeDescripiton;
        self.numberOfParticipants = numberOfParticipants;
    }
}
