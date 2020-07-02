//
//  RegisterViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/30/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextFIeld: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerButtonPressed(_ sender: Any) {
        let email = emailTextField.text!;
        let username = usernameTextFIeld.text!;
        let password = passwordTextField.text!;
        
        Team3Helper.colorTextFieldBorder(textField: usernameTextFIeld, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: emailTextField, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: passwordTextField, isRed: false)
        
        if username == "" {
            Team3Helper.colorTextFieldBorder(textField: usernameTextFIeld, isRed: true)
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
        
        UserAuthentication.registerUser(username: username, email: email, password: password) {
            (authResult, err) in
            // https://github.com/firebase/quickstart-ios/blob/9ece2b1bbd4beaedaf53c782f518de8cfc38bed2/authentication/AuthenticationExampleSwift/EmailViewController.swift#L159-L170
            guard let user = authResult?.user, err == nil else {
                print("Errors:")
                self.present(Team3Helper.makeAlert(err!.localizedDescription), animated: true)
                return
            }
            
            // Add Username
            
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
