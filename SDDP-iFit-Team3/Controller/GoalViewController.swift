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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGoals()
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return goalList.count

     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
        let g = goalList[indexPath.row]
        for activity in healthKitActivityList{
            // g.date + g.duration
            // activity.todayStep
        }
         let cell : GoalCell = tableView
         .dequeueReusableCell (withIdentifier: "GoalCell", for: indexPath) as! GoalCell

       
        cell.goalTitle.text = g.goalTitle;
        cell.percentageLabel.text = "\(g.progressPercent * 10)%";
        cell.duration.text = "\(g.duration) "
        
        cell.dateRange.text = "\(g.date)" 
        cell.progressView.setProgress(Float(g.progressPercent) / 10 , animated: false)
        
      //  cell.progressView.transform = cell.progressView.transform.scaledBy(x: 1, y: 15)
       // cell.selectionStyle = .none

                 return cell
         }
    
    func loadGoals() {
        self.goalList = []
        
        self.goalTableView.isHidden = true
        self.noGoalLabel.isHidden = false
      //  self.noSchedulesLabel.isHidden = false
        
        if let user = UserAuthentication.getLoggedInUser() {
            print("User is logged in")
        
            DataManager.Goals.loadGoals(userId: user.uid) { (data) in
                    if data.count > 0 {
                        print("data loaded")
                        self.goalList = data
                        print(data.count)
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
        DataManager.HealthKitActivities.loadHealthKitActivity(userId: UserAuthentication.user!.userId){
            (data) in
            if data.count > 0 {
                self.healthKitActivityList = data
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGoalDetails" {
            let detailViewController = segue.destination as! GoalDetailsViewController
            let indexPath = self.goalTableView.indexPathForSelectedRow
            
            if indexPath != nil {

                let goal = self.goalList[indexPath!.row]
                detailViewController.goal = goal
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
