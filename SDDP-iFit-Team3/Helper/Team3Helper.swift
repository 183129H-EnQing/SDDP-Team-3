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
    static let notificationCenter = UNUserNotificationCenter.current()
    
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
    
    static func ifInputIsFloatt(someInput: String) -> Bool {
        guard let _ = Float(someInput) else {return false}
        
        return true
    }
    
    static func colorTextFieldBorder(textField: UITextField, isRed: Bool) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = isRed ? UIColor.systemRed.cgColor : UIColor.systemGray3.cgColor
    }
    
    static func changeRootScreen(currentController: UIViewController, goToTabs: Bool, tookSurvey: Bool) {
        // https://stackoverflow.com/a/22654105
        let controller = goToTabs ? currentController.storyboard?.instantiateViewController(identifier: "TabBarController") : currentController.storyboard?.instantiateViewController(identifier: "WelcomeNavController")
        
        UIApplication.shared.windows[0].rootViewController = controller
        if goToTabs && !tookSurvey {
            print("Hello")
            let surveyVC = SceneDelegate.profileStoryboard.instantiateViewController(identifier: "SurveyHome")
            controller?.present(surveyVC, animated: true)
        }
    }
    
    static func createNotificationContent(title: String, message: String, subtitle: String? = nil) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        return content
    }
    
    static func makeImgViewRound(_ imageView: UIImageView) {
        // circle image ref: https://www.ioscreator.com/tutorials/circular-image-view-ios-tutorial
        imageView.layer.masksToBounds = true
        imageView.layer.backgroundColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.bounds.height/2
    }
}
