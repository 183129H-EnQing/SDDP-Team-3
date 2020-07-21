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
    @IBOutlet weak var bmiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Team3Helper.makeImgViewRound(avatarImgView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let user = UserAuthentication.user {
                if let url = user.avatarURL {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.avatarImgView.image = UIImage(data: data)
                        }
                    }
                }

                var bmiMsg = "No BMI, please take the survey!"
                
                if let fitnessInfo = user.fitnessInfo {
                    let weight = fitnessInfo.weight
                    let height = fitnessInfo.height
                    bmiMsg = "BMI: \(weight/pow(height, height))"
                }
                
                DispatchQueue.main.async {
                    self.usernameLabel.text = (user.username != nil) ? user.username : "Need set username for Auth"
                    self.bmiLabel.text = bmiMsg
                }
            }
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserAuthentication.logoutUser("Successfully logged out! Thank you for using our app!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditProfile" {
            let editController = segue.destination as! EditProfileViewController
            editController.previousAvatar = self.avatarImgView.image
            if let username = UserAuthentication.user?.username {
                editController.previousUsername = username
            }
        } else if segue.identifier == "RetakeFitnessSurvey" {
            
        }
    }
}
