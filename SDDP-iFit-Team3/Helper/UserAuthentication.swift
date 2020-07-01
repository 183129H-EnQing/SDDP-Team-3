//
//  UserAuthentication.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/30/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


class UserAuthentication {
    
    static func registerUser(username: String, email: String, password: String) {
        return Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            
        }
    }
}
