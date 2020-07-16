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
    
    static func updatePassword(password: String, onComplete: UserProfileChangeCallback?) {
        UserAuthentication.getLoggedInUser()?.updatePassword(to: password, completion: onComplete)
    }
    
    static func initUser(user: FirebaseAuth.User?, onComplete: ((User?) -> Void)?) {
        if let user = user {
            DispatchQueue.global(qos: .default).async {
                DataManager.getUserData(userId: user.uid) { (actUser) in
                    if let actUser = actUser {
                        print("Able to initialise user")
                        
                        UserAuthentication.user = actUser
                    }
                    print("after")
                    onComplete?(actUser)
                }
            }
            print("done")
        }
    }
    
    static func logoutUser(_ message: String) {
        do {
            try Auth.auth().signOut()
            UserAuthentication.user = nil
            UIApplication.shared.windows[0].rootViewController = SceneDelegate.mainStoryboard.instantiateViewController(identifier: "WelcomeNavController")
            UIApplication.shared.windows[0].rootViewController!.present(Team3Helper.makeAlert(message), animated: true)
        } catch let signoutErr as NSError {
            print("Failed to sign out: \(signoutErr)")
        }
    }
    
}
