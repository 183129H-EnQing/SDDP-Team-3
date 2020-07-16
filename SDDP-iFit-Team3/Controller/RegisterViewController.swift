//
//  RegisterViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/30/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var usernames: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataManager.loadUsernames() { usernames in
            print("Loading Usernames: \(usernames)")
            
            self.usernames = usernames
        }
    }
    

    @IBAction func registerButtonPressed(_ sender: Any) {
        let email = emailTextField.text!;
        let username = usernameTextField.text!;
        let password = passwordTextField.text!;
        
        Team3Helper.colorTextFieldBorder(textField: usernameTextField, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: emailTextField, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: passwordTextField, isRed: false)
        
        if username == "" {
            Team3Helper.colorTextFieldBorder(textField: usernameTextField, isRed: true)
            self.present(Team3Helper.makeAlert("Username cannot be empty"), animated: true)
            return
        }
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
        
        // Load Username array to check that the username is not taken
        var isUsernameTaken = false
        for user in self.usernames {
            if user.value.elementsEqual(username) {
                isUsernameTaken = true
                break
            }
        }
                
        if isUsernameTaken {
            Team3Helper.colorTextFieldBorder(textField: usernameTextField, isRed: true)
            self.present(Team3Helper.makeAlert("Username is taken!"), animated: true)
            return
        }
        
        UserAuthentication.registerUser(email: email, password: password) {
            (authResult, err) in
            // https://github.com/firebase/quickstart-ios/blob/9ece2b1bbd4beaedaf53c782f518de8cfc38bed2/authentication/AuthenticationExampleSwift/EmailViewController.swift#L159-L170
            guard let user = authResult?.user, err == nil else {
                let errCode = (err! as NSError).code
                var errMsg = err?.localizedDescription
                
                if errCode == AuthErrorCode.invalidEmail.rawValue {
                    errMsg = "Invalid email"
                }
                
                self.present(Team3Helper.makeAlert(errMsg!), animated: true)
                return
            }
            
            // Add Username after user is successfully registered
            DataManager.addUser(userId: user.uid, username: username, email: email)
            
            print("\(user.email!) successfully created!")
            print("\(user.providerID) successfully created!")
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.viewControllers[0].present(Team3Helper.makeAlert("Success Registration! Go login!"), animated: true)
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
