//
//  SceneDelegate.swift
//  SDDP-iFit-Team3
//
//  Created by M09-1 on 6/11/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // https://stackoverflow.com/a/30592893
        if let user = UserAuthentication.getLoggedInUser() {
            print("redirecting to tab bar since user is logged in")

            UserAuthentication.initUser(user: user) { user in
                let controller = SceneDelegate.mainStoryboard.instantiateViewController(identifier: "TabBarController")
                self.window?.rootViewController = controller
            }
            
            // We want to make 1 notification for a schedule NOT yet occurred
            DataManager.Schedules.loadSchedules(userId: user.uid) { (daySchedules) in
                let actualDateComp = Calendar.current.dateComponents([.weekday, .hour, .minute], from: Date())
                
                print("weekDay: \(actualDateComp.weekday!)")
                
                // need to minus 1, cause weekDay starts is 1 to 7
                // we try to get schedules for the current day
                if let schedules = daySchedules[actualDateComp.weekday!-1] {
                    print("there exists schedule(s) for today!")
                    var scheduleNotifReq: UNNotificationRequest? = nil
                    
                    for schedule in schedules {
                        let schHr = schedule.time[0]
                        let schMin = schedule.time[1]
                        
                        /* 1. We check if hours are the same, if so, check that current minute is less than schedule's minute
                          2. If hours not equal, then check if current hour is lesser */
                        if (actualDateComp.hour == schHr && actualDateComp.minute! < schMin) || actualDateComp.hour! < schHr {
                            print("making notif req!")
                            scheduleNotifReq = Team3NotificationCenterDelegate.makeNotification(schedule: schedule, userId: user.uid)
                            break
                        }
                    }
                    
                    if let scheduleNotifReq = scheduleNotifReq {
                        DispatchQueue.main.async {
                            print("sending notif")
                            Team3Helper.notificationCenter.add(scheduleNotifReq, withCompletionHandler: nil)
                        }
                    }
                }
            }
        } else {
            print("No redirect, user to stay at welcome  since they are not logged in")
        }
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

