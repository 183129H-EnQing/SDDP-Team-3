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
        print("request identifier: \(request.identifier)")
        print("content title: \(content.title)")
        print("content body: \(content.body)")
        
        if request.identifier.contains("scheduler") {
            /* identifier would be "scheduler.scheduleId.userId" */
            let identifierArr = request.identifier.split(separator: ".")
            
            let scheduleId: String = identifierArr[1].description
            let userId: String = identifierArr[2].description
            
            print("is a scheduler notification!")
            print(identifierArr)
            
            DataManager.Schedules.getSchedule(scheduleId) { (ogSchedule) in
                if let ogSchedule = ogSchedule {
                    let hour = ogSchedule.time[0]
                    let min = ogSchedule.time[1]
                    DataManager.Schedules.loadSchedules(userId: userId) { (daySchedules) in
                        var nextNotifReq: UNNotificationRequest? = nil
                        if let schedules = daySchedules[ogSchedule.day] {
                            var notificationIdentifiers: [String] = []
                            for schedule in schedules {
                                if schedule.time[0] < hour || (schedule.time[0] == hour && schedule.time[1] < min) {
                                    let identifier = "scheduler.\(schedule.id!).\(userId)"
                                    
                                    notificationIdentifiers.append(identifier)
                                } else if schedule.id != scheduleId {
                                    nextNotifReq = self.makeNotification(schedule: schedule, userId: userId)
                                }
                            }
                            center.removeDeliveredNotifications(withIdentifiers: notificationIdentifiers)
                            center.removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
                        }
                        
                        if let nextNotifReq = nextNotifReq {
                            center.add(nextNotifReq)
                        }
                    }
                }
            }
        }
    }
    
    func makeNotification(schedule: Schedule, userId: String) -> UNNotificationRequest {
        print("going to add notification")
        let duration = schedule.duration
            
        let timeMsg = (duration[0] > 0 ? "\(duration[0]) hrs" : "") + (duration[0] > 0 && duration[1] > 0 ? " " : "") + (duration[1] > 0 ? "\(duration[1]) mins" : "")
        let content = Team3Helper.createNotificationContent(title: "Scheduler", message: "\(SchedulerDetailsViewController.exercises[schedule.exerciseId]) - \(timeMsg)")
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        dateComponents.hour = schedule.time[0]
        dateComponents.minute = schedule.time[1]
        
        print("making notification")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        return UNNotificationRequest(identifier: "scheduler.\(schedule.id!).\(userId)", content: content, trigger: trigger)
    }
}
