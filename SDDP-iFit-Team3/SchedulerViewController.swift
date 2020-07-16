//
//  SchedulerViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/22/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // {day as Integer: Array of Schedule}
    var schedules: [Int: [Schedule]] = [:]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noSchedulesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Find meeeeeeee schedules!")
        
        let calender = Calendar.current
        
        var testDate = DateComponents()
        testDate.day = 4
        testDate.month = 7
        testDate.year = 2020
        let actualDateComp = calender.dateComponents([.weekday, .weekdayOrdinal, .hour, .minute], from: calender.date(from: testDate)!)
        print("Actual day: \(actualDateComp.weekday!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadSchedules()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = getDayInSchedules(section: section)
        return self.schedules[day]!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.schedules.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = getDayInSchedules(section: section)
        return SchedulerDetailsViewController.days[day]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)
        
        let day = getDayInSchedules(section: indexPath.section)
        let schedule = self.schedules[day]![indexPath.row]
        
        // Set exercise as title label,sStyle the duration string
        let exerciseName = SchedulerDetailsViewController.exercises[schedule.exerciseId]
        
        // Set duration
        let durationHr = schedule.duration[0]
        let durationMin = schedule.duration[1]
        let durationMsg = (durationHr > 0 ? "\(durationHr) hrs" : "") + (durationHr > 0 && durationMin > 0 ? " " : "") + (durationMin > 0 ? "\(durationMin) mins" : "")
        
        cell.textLabel?.text = "\(exerciseName) - \(durationMsg)"
        
        // Convert from 24 hour to 12 hour time and style the time string
        let timeHour = schedule.time[0]
        let timeMin: Int = schedule.time[1]
        let hourHand = timeHour > 12 ? timeHour - 1 : (timeHour > 0 ? timeHour : 12)
        let minuteHand = timeMin > 9 ? "\(timeMin)" : "0\(timeMin)"
        let timeType = (schedule.time[0] > 11 ? "PM" : "AM")
        
        cell.detailTextLabel?.text =  "\(hourHand):\(minuteHand) \(timeType)"
        
        return cell;
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let section = indexPath.section
            let day = getDayInSchedules(section: section)
            
            print("Before: \(schedules)")
            print("Day: \(day), Section: \(section), Row: \(indexPath.row)")
            
            //self.schedules[day]?.remove(at: indexPath.row)
            DataManager.Schedules.deleteSchedule(schedule: self.schedules[day]![indexPath.row]) { (isSuccess) in
                if isSuccess {
                    self.loadSchedules()
                } else {
                    self.present(Team3Helper.makeAlert("Wasn't able to delete this schedule"), animated: true)
                }
            }
        }
    }
    @IBAction func notifyButtonPressed(_ sender: Any) {
        Team3Helper.notificationCenter.getNotificationSettings { (settings) in
            let status = settings.authorizationStatus
            if status == .denied || status == .notDetermined {
                print("Denied!")
                return
            }
            
            let content = Team3Helper.createNotificationContent(title: "Test", message: "Hello world")
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            
            Team3Helper.notificationCenter.add(UNNotificationRequest(identifier: "scheduler.test", content: content, trigger: trigger))
        }
    }
    
    func getDayInSchedules(section: Int) -> Int {
        let day = Array(self.schedules.keys).sorted(by: {
            (a,b) in
            return a < b
        })[section]
        
        return day
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSchedule" {
            let detailViewController = segue.destination as! SchedulerDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if indexPath != nil {
                let day = getDayInSchedules(section: indexPath!.section)
                let schedule = self.schedules[day]![indexPath!.row]
                detailViewController.schedule = schedule
                detailViewController.scheduleIndex = indexPath!.row
            }
        }
    }

    func loadSchedules() {
        self.schedules = [:]
        
        self.tableView.isHidden = true
        self.noSchedulesLabel.isHidden = false
        
        if let user = UserAuthentication.getLoggedInUser() {
            print("User is logged in")
            DataManager.Schedules.loadSchedules(userId: user.uid) { (data) in
                print("loading from firebase")
                if data.count > 0 {
                    print("data loaded")
                    self.schedules = data
                    
                    DispatchQueue.main.async {
                        print("async tableview label")
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        self.noSchedulesLabel.isHidden = true
                    }
                }
            }
        }
    }
}
