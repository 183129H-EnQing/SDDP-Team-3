//
//  AppDelegate.swift
//  SDDP-iFit-Team3
//
//  Created by M09-1 on 6/11/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import Firebase
import Fritz

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notifyCenterDelegate = Team3NotificationCenterDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("AppDelegate didFinishLaunch")
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Team3Helper.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (isGranted, err) in
            if !isGranted {
                print("Notification Perm not granted")
            } else if let err = err {
                print("Error getting notification perm: \(err)")
            }
        }
        Team3Helper.notificationCenter.delegate = notifyCenterDelegate
        FritzCore.configure()
        
        Team3Helper.notificationCenter.removeAllPendingNotificationRequests()
        Team3Helper.notificationCenter.removeAllDeliveredNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

