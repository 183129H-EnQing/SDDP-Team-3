//
//  Team3NotificationCenterDelegate.swift
//  SDDP-iFit-Team3
//
//  Created by Gary Lam on 15/8/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class Team3NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let action = response.actionIdentifier
        let request = response.notification.request
        let content = request.content.mutableCopy() as! UNMutableNotificationContent
        
        print("action: \(action)")
        print("content title: \(content.title)")
        print("content body: \(content.body)")
    }
}
