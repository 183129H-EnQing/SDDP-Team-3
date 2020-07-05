//
//  Team3Helper.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/26/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation
import UIKit

class Team3Helper {
    // since this function is needed in more than 1 class, made a helper class to put re-used functions
    static func makeAlert(_ message:String) -> UIAlertController {
       let alert = UIAlertController(
           title: message,
           message: "",
           preferredStyle: UIAlertController.Style.alert)
       
       alert.addAction(
           UIAlertAction(
               title: "OK",
               style: UIAlertAction.Style.default,
               handler: nil
           )
       )
       
       return alert
    }
    
    static func ifInputIsInt(someInput: String) -> Bool {
        guard let _ = Int(someInput) else {return false}
        
        return true
    }
    
    static func colorTextFieldBorder(textField: UITextField, isRed: Bool) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = isRed ? UIColor.systemRed.cgColor : UIColor.systemGray3.cgColor
    }
    
    static func changeRootScreen(currentController: UIViewController, goToTabs: Bool) {
        // https://stackoverflow.com/a/22654105
        let controller = goToTabs ? currentController.storyboard?.instantiateViewController(identifier: "TabBarController") : currentController.storyboard?.instantiateViewController(identifier: "WelcomeNavController")
        UIApplication.shared.windows[0].rootViewController = controller
    }
}
