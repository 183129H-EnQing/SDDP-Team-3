//
//  GoalViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 29/6/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

   
    @IBOutlet weak var noGoalLabel: UILabel!
    @IBOutlet weak var goalTableView: UITableView!
    var goalList : [Goal] = []
    var healthKitActivityList : [HealthKitActivity] = []
    var processPercentArray : [Double] = []
    var activityType : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGoals()
        loadHealthKitData()
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return goalList.count

     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.timeZone  = TimeZone(identifier: "Asia/Singapore") // US_POSIX - usa , en_SG
        formatter.dateFormat = "dd MMM yyyy"
           
        let g = goalList[indexPath.row]
        let startDate = formatter.date(from:g.date)!
        let endDate = calendar.date(byAdding: .day, value: g.duration, to: startDate)!

        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        let startEndDateRange = startDateString ... endDateString // An Array range of dates
//        print(startEndDateRange)
//        print("startDate: \(startDateString)")
//        print("endDate: \(endDateString)")
  
        let cell : GoalCell = tableView
             .dequeueReusableCell (withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        let goalId = g.goalId!
        var processPercent : Double = 0
        var totalSteps : Double = 0
        var totalCalories : Double = 0
          
        // Move to a background thread to do some long running work
        DispatchQueue.global(qos: .userInitiated).async {
               for activityData in self.healthKitActivityList{
                        // Check whether the date is in between or start or end, if true - do something to the data, false-ignore data
                        
                        if startEndDateRange.contains(activityData.dateSaved){
                            print(startEndDateRange.contains(activityData.dateSaved))
                            totalSteps += activityData.todayStep
                            totalCalories += activityData.todayCaloriesBurnt
                        }
                    }
            
                if (g.activityName == "Steps"){
                    print(totalSteps)
                    print(g.totalExerciseAmount)
                    processPercent = totalSteps / Double(g.totalExerciseAmount)
                    print(totalSteps / Double(g.totalExerciseAmount))
                    print("hello")
                    self.updateGoalProcessPercent(goalId: goalId,processPercent: processPercent)
                    self.processPercentArray.append(processPercent)
                }
                if (g.activityName == "Running"){
                    processPercent = totalCalories / Double(g.totalExerciseAmount)
                    self.updateGoalProcessPercent(goalId:goalId,processPercent: processPercent)
                    self.processPercentArray.append(processPercent)
                }
//                if (g.activityName == ""){
//                    processPercent =
//                    self.updateGoalProcessPercent(goalId: goalId,)
//                }
//               update progress
            
            
               // Bounce back to the main thread to update the UI
               DispatchQueue.main.async {
                   cell.goalTitle.text = g.goalTitle;
                   cell.percentageLabel.text = "\(processPercent * 100)%";
                   cell.duration.text = "Duration: \(g.duration) Days"
                   
                   cell.dateRange.text = "Starting Date: \(g.date)"
                   cell.progressView.setProgress(Float(processPercent) , animated: false)

               }
           }
        
        return cell
    }
    
    
    func loadGoals() {
        self.goalList = []
        
        self.goalTableView.isHidden = true
        self.noGoalLabel.isHidden = false
      //  self.noSchedulesLabel.isHidden = false
        
        if let user = UserAuthentication.getLoggedInUser() {
            //print("User is logged in")
        
            DataManager.Goals.loadGoals(userId: user.uid) { (data) in
                    if data.count > 0 {
                       // print("data loaded")
                        self.goalList = data
                      //  print(data.count)
                        DispatchQueue.main.async {
                            print("async tableview label")
                            self.goalTableView.reloadData()
                            self.goalTableView.isHidden = false
                            self.noGoalLabel.isHidden = true
                        }
                    }
                }
        }
    }
    
    func loadHealthKitData(){
        print("1")
        DataManager.HealthKitActivities.loadHealthKitActivity(userId: UserAuthentication.user!.userId){
            (data) in
            if data.count > 0 {
                self.healthKitActivityList = data
            }
        }
    }
    
    func updateGoalProcessPercent(goalId: String,processPercent:Double){
        DataManager.Goals.updateGoalProcessPercent(processPercent: processPercent, goalId: goalId){ (isSuccess) in
                              print("success i guess")
                          }
    }
    func addActivityDataToVariable(){
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGoalDetails" {
            let detailViewController = segue.destination as! GoalDetailsViewController
            let indexPath = self.goalTableView.indexPathForSelectedRow
            
            if indexPath != nil {

                let goal = self.goalList[indexPath!.row]
                detailViewController.goal = goal
                detailViewController.processPercent = processPercentArray[indexPath!.row]
                print(processPercentArray[indexPath!.row])
                print(goal.progressPercent)
            //    detailViewController.processPercent = goal.progressPercent
            }
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
