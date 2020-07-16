//
//  User.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/13/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation

class User {
    var userId: String
    var email: String
    var username: String?
    var avatarURL: URL?
    var fitnessInfo: FitnessInfo?
    var tookSurvey: Bool?
    
    init(userId: String, email: String) {
        self.userId = userId
        self.email = email
    }
}

class FitnessInfo: Codable {
    var weight: Float
    var height: Float
    
    init(weight: Float, height: Float) {
        self.weight = weight
        self.height = height
    }
}
