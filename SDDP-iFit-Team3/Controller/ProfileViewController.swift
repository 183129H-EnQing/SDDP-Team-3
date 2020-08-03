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
    
    @IBOutlet weak var heightWeightStackView: UIStackView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var riskLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Team3Helper.makeImgViewRound(avatarImgView)
        Team3Helper.colorTextFieldBorder(textField: heightView, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: weightView, isRed: false)
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
                var riskMsg = "Your classification is  "
                var showHeightWeight = false
                
                if let fitnessInfo = user.fitnessInfo {
                    let weight = fitnessInfo.weight
                    let height = fitnessInfo.height
                    let bmi: Float = weight/pow(height, height)
                    bmiMsg = "BMI: " + String(format: "%.1f", bmi)
                    showHeightWeight = true
                    
                    riskMsg += self.getRisk(bmi)
                }
                
                DispatchQueue.main.async {
                    self.usernameLabel.text = (user.username != nil) ? user.username : "Need set username for Auth"
                    self.bmiLabel.text = bmiMsg
                    
                    self.heightWeightStackView.isHidden = !showHeightWeight
                    self.riskLabel.isHidden = !showHeightWeight
                    
                    if showHeightWeight {
                        self.heightLabel.text = String(format: "%.0f", user.fitnessInfo!.height * 100) + " cm"
                        self.weightLabel.text = String(format: "%.1f", user.fitnessInfo!.weight) + " kg"
                        
                        self.riskLabel.text = riskMsg
                    }
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
            if let fitnessinfo = UserAuthentication.user?.fitnessInfo {
                let surveyController = segue.destination as! SurveyFormViewController
                surveyController.fitnessInfo = fitnessinfo
            }
        }
    }
    
    func getRisk(_ bmi:Float) -> String {
        if bmi < 18.5 {
            return "Underweight"
        } else if bmi <= 24.9 {
            return "Normal"
        } else if bmi <= 29.9 {
            return "Overweight"
        } else {
            return "Obese"
        }
    }
}
