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
    var processPercent: Double = 0;
    
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
            formatter.timeZone  = TimeZone(identifier: "Asia/Singapore") // US_POSIX - usa , en_SG
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
            let processPercentString = String(format: "%.2f", processPercent * 100)
            exerciseProgressPercent.text = "\(processPercentString)%"
            let totalAmountExeciseDoneRoundOff = (processPercent * Double(unwrappedGoal.totalExerciseAmount)).rounded()
            totalAmountExerciseDone.text = "\(totalAmountExeciseDoneRoundOff)"
            
            exerciseProgressBar.setProgress(Float(processPercent) , animated: false)
            exerciseProgressBar.transform = exerciseProgressBar.transform.scaledBy(x: 1, y: 10)
             
           // let todayDate = calendar.dateComponents([.year, .month, .day], from: Date())
            let todayDateString = formatter.string(from: Date())
            let todayDate = formatter.date(from: todayDateString)!
            print("todadate",todayDateString)
            //print(processPercent)
            let components = calendar.dateComponents([.day], from: todayDate, to: endDate)
            //print("\(components.day!)")
            deadLine.text = "\(components.day!)" + "Days more"
            totalDuration.text = "\(unwrappedGoal.duration)" + "Days"
            //exerciseProgressTitle.text = unwrappedGoal.
            // date duration
        }
     

    }
    
    @IBAction func endGoalPressed(_ sender: Any) {
        let status = "Finish Goal"
        let goalId = self.goal!.goalId!
        print(goalId)
        
        let viewControllers = self.navigationController?.viewControllers
        let parent = viewControllers?[1] as! GoalViewController
        
        if self.goal != nil {
              // Update
        DataManager.Goals.updateGoalStatus(status: status, goalId: goalId){ (isSuccess) in
                self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
            }
            if let user = UserAuthentication.getLoggedInUser() {
                
                 var playerGameData: Game = Game(armyCount: 0, planets: 0, userId: "", points: 0, score: 0)
                DataManager.GamesClass.loadGame(userId: user.uid) { (data) in
                    
                    playerGameData = data!
                    
                    DataManager.GamesClass.updateGame(userId: user.uid, game: Game(armyCount: playerGameData.armyCount, planets: playerGameData.planets, userId: user.uid, points: playerGameData.points + 10, score: playerGameData.score)) { (success) in
                        print("updated db")
                    }
                }
            }
       

    }
        
    }
    func afterDbOperation(parent: GoalViewController, isSuccess: Bool, isUpdating: Bool) {
                if !isSuccess {
                    let mode = isUpdating ? "updating the" : "adding a"
                    self.present(Team3Helper.makeAlert("Wasn't successful in \(mode) goal"), animated: true)
                }
                
                parent.loadGoals()
                self.navigationController?.popViewController(animated: true)
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
    

