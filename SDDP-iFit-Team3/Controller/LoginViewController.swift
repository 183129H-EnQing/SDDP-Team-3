//
//  LoginViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/30/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        let tabBarController = self.storyboard?.instantiateViewController(identifier: "TabBarController")
        
        let email = emailTextField.text!;
        let password = passwordTextField.text!;
        
        Team3Helper.colorTextFieldBorder(textField: emailTextField, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: passwordTextField, isRed: false)
        
        if email == "" {
            Team3Helper.colorTextFieldBorder(textField: emailTextField, isRed: true)
            self.present(Team3Helper.makeAlert("Email cannot be empty"), animated: true)
            return
        }
        if password == "" {
            Team3Helper.colorTextFieldBorder(textField: passwordTextField, isRed: true)
            self.present(Team3Helper.makeAlert("Password cannot be empty"), animated: true)
            return
        }
        
        UserAuthentication.loginUser(email: email, password: password) { (authResult, err) in
            guard let user = authResult?.user, err == nil else {
                let errCode = (err! as NSError).code
                var errMsg = err?.localizedDescription
                
                if errCode == AuthErrorCode.invalidEmail.rawValue {
                    errMsg = "Invalid email"
                } else if errCode == AuthErrorCode.userNotFound.rawValue {
                    errMsg = "Account does not exist for email used"
                } else if errCode == AuthErrorCode.wrongPassword.rawValue {
                    errMsg = "Wrong password used"
                }
                
                self.present(Team3Helper.makeAlert(errMsg!), animated: true)
                
                return
            }
            
            print("\(user.email!) successfully logged in!")
            // https://stackoverflow.com/a/22654105
            UIApplication.shared.windows[0].rootViewController = tabBarController
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
