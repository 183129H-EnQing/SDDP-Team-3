//
//  SurveyFormViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/16/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class SurveyFormViewController: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        Team3Helper.colorTextFieldBorder(textField: weightTextField, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: heightTextField, isRed: false)
        
        if !Team3Helper.ifInputIsFloatt(someInput: weightTextField.text!) {
            Team3Helper.colorTextFieldBorder(textField: weightTextField, isRed: true)
            
            let alert = Team3Helper.makeAlert("Only numbers allowed in 'Weight' text field")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if !Team3Helper.ifInputIsFloatt(someInput: heightTextField.text!) {
            Team3Helper.colorTextFieldBorder(textField: heightTextField, isRed: true)
            
            let alert = Team3Helper.makeAlert("Only numbers allowed in 'Height' text field")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let weight = Float(weightTextField.text!)!
        let height = Float(heightTextField.text!)!
        
        UserAuthentication.user?.fitnessInfo = FitnessInfo(weight: weight, height: height)
        DataManager.updateUser(userId: UserAuthentication.user!.userId, userData: [
            "fitnessInfo": [
                "weight": weight,
                "height": height
            ]
        ])
        print("isPresented: \(self.isBeingPresented)")
        
        if self.presentingViewController?.presentedViewController == self {
            let parent = self.presentingViewController
            self.dismiss(animated: true) {
                parent?.dismiss(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
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
