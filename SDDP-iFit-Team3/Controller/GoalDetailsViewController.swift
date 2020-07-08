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
    @IBOutlet weak var dateDuration: UIView!
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
             print(unwrappedGoal.activityName)
            print(String(unwrappedGoal.totalExerciseAmount))
            goalTitle.text = unwrappedGoal.goalTitle
            exerciseProgressTitle.text = unwrappedGoal.activityName + "Completed"
            exerciseProgressPercent.text = "0"
            totalAmountExerciseDone.text = "0"
             
            //totalDuration.text = unwrappedGoal
            //exerciseProgressTitle.text = unwrappedGoal.
            // date duration
        }
        goalTitle.text = goal?.goalTitle
//        var totalExerciseAmount = "\(goal?.totalExerciseAmount)"
//        var exerciseProgressTitleText = "\(totalExerciseAmount), \(goal?.activityName)"
//        exerciseProgressTitle.text =
        
        // dateDuration
     

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
