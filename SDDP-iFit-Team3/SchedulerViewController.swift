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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.schedules = [
            2: [
                Schedule(exerciseName: "Jumping Jacks", duration: [2,50], day: 2, time: [0, 10])
            ],
            0: [
                Schedule(exerciseName: "Push Up", duration: [0, 5], day: 0, time: [10, 0]),
                Schedule(exerciseName: "Jumping Jacks", duration: [0, 10], day: 0, time: [10, 30]),
                Schedule(exerciseName: "Skipping Rope", duration: [1, 10], day: 0, time: [12, 50])
            ],
            1: [
                Schedule(exerciseName: "Push Up", duration: [0, 5], day: 1, time: [10, 0])
            ]
        ]
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
        let duration = (schedule.duration[0] > 0 ? "\(schedule.duration[0]) hrs " : "") + "\(schedule.duration[1]) mins"
        cell.textLabel?.text = "\(schedule.exerciseName) - \(duration)"
        
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
            print("Count: \(self.schedules[day]!.count)")
            
            self.schedules[day]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            print("Count: \(self.schedules[day]!.count)")
            if self.schedules[day]!.count == 0 {
                self.schedules.removeValue(forKey: day)
            }
            
            tableView.reloadData()
            print("After: \(schedules)")
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
            }
        }
    }

}
