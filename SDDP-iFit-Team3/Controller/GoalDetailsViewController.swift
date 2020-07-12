//
//  GoalDetailsViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 7/8/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class GoalDetailsViewController: UIViewController {

    @IBOutlet weak var goalTitle: UILabel!
    
    @IBOutlet weak var dateDuration: UILabel!
    @IBOutlet weak var totalAmountExerciseDone: UILabel!
    @IBOutlet weak var exerciseProgressTitle: UILabel!
    @IBOutlet weak var exerciseProgressPercent: UILabel!
    @IBOutlet weak var exerciseProgressBar: UIProgressView!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var deadLine: UILabel!
    
    var goal : Goal?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // This function is triggered when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let unwrappedGoal = self.goal {
            let calendar = Calendar.current
            let formatter = DateFormatter()
            formatter.timeZone  = TimeZone(identifier: "Asia/Singapore") // set locale to reliable US_POSIX - usa , en_SG - sg
            formatter.dateFormat = "dd MMM yyyy"
            
            let startDate = formatter.date(from:unwrappedGoal.date)!
            let endDate = calendar.date(byAdding: .day, value: unwrappedGoal.duration, to: startDate)!
            //print("startDate:",startDate)
            //print("endDate with wrap:",endDate)
            
            let startDateString = formatter.string(from: startDate)
            let endDateString = formatter.string(from: endDate)
            //print("end date:",endDateString)
            dateDuration.text = startDateString + "-" + endDateString
       
        
            goalTitle.text = unwrappedGoal.goalTitle
            exerciseProgressTitle.text = unwrappedGoal.activityName + " Completed"
            // exercise done / totalAmountExercise = Total Exercise Done
            exerciseProgressPercent.text = "\(unwrappedGoal.progressPercent)%"
            totalAmountExerciseDone.text = "0" // need fetch data to update the data status
            
            exerciseProgressBar.setProgress(Float(unwrappedGoal.progressPercent) / 10, animated: false)
            exerciseProgressBar.transform = exerciseProgressBar.transform.scaledBy(x: 1, y: 10)
             
           // let todayDate = calendar.dateComponents([.year, .month, .day], from: Date())
            let todayDateString = formatter.string(from: Date())
            let todayDate = formatter.date(from: todayDateString)!
            //print("todadate",todayDateString)
            let components = calendar.dateComponents([.day], from: todayDate, to: endDate)
            //print("\(components.day!)")
            deadLine.text = "\(components.day!)" + "Days more"
            totalDuration.text = "\(unwrappedGoal.duration)" + "Days"
            //exerciseProgressTitle.text = unwrappedGoal.
            // date duration
        }
     

    }
    @IBAction func endGoalPressed(_ sender: Any) {
        
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
