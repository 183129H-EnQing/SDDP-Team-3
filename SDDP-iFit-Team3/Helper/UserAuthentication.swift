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
    
    static func registerUser(username: String, email: String, password: String, onComplete: AuthDataResultCallback?) {
        return Auth.auth().createUser(withEmail: email, password: password, completion: onComplete)
    }
    
    static func loginUser(email: String, password: String, onComplete: AuthDataResultCallback?) {
        return Auth.auth().signIn(withEmail: email, password: password, completion: onComplete)
    }
    
    static func getLoggedInUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch let signoutErr as NSError {
            print("Failed to sign out: \(signoutErr)")
        }
    }
    
}
