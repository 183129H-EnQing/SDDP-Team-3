//
//  UserAuthentication.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/30/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation
import Firebase

class UserAuthentication {
    
    static var user: User?
    
    static func registerUser(email: String, password: String, onComplete: AuthDataResultCallback?) {
        return Auth.auth().createUser(withEmail: email, password: password, completion: onComplete)
    }
    
    static func loginUser(email: String, password: String, onComplete: AuthDataResultCallback?) {
        return Auth.auth().signIn(withEmail: email, password: password, completion: onComplete)
    }
    
    static func getLoggedInUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    static func logoutUser() {
        do {
            try Auth.auth().signOut()
            UserAuthentication.user = nil
            UIApplication.shared.windows[0].rootViewController = SceneDelegate.mainStoryboard.instantiateViewController(identifier: "WelcomeNavController")
            UIApplication.shared.windows[0].rootViewController!.present(Team3Helper.makeAlert("Success Registration! Go login!"), animated: true)
        } catch let signoutErr as NSError {
            print("Failed to sign out: \(signoutErr)")
        }
    }
    
}
