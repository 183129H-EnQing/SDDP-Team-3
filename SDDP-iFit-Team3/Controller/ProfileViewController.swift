//
//  ProfileViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/11/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = UserAuthentication.user {
            self.usernameLabel.isHidden = false
            self.usernameLabel.text = (user.username != nil) ? user.username : "Need set username for Auth"
        
            if let url = user.avatarURL {
                if let data = try? Data(contentsOf: url) {
                    self.avatarImgView.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserAuthentication.logoutUser()
        UIApplication.shared.windows[0].rootViewController = SceneDelegate.mainStoryboard.instantiateViewController(identifier: "WelcomeNavController")
        UIApplication.shared.windows[0].rootViewController!.present(Team3Helper.makeAlert("Success Registration! Go login!"), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditProfile" {
            let editController = segue.destination as! EditProfileViewController
            editController.previousAvatar = self.avatarImgView.image
            if let username = UserAuthentication.user?.username {
                editController.usernameTextField.text = username
            }
        }
    }
}
