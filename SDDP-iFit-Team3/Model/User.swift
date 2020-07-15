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
    
    init(userId: String, email: String) {
        self.userId = userId
        self.email = email
    }
}
