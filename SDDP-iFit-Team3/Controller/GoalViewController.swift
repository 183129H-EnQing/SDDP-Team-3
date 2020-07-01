//
//  GoalViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 29/6/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

   
    @IBOutlet weak var goalTableView: UITableView!
    var goalList : [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goalList.append(Goal(goalTitle: "10KM", activityName: "Running", date: "1/7/2020", duration: 7, progressPercent: 10, totalExerciseAmount: 10))
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return 1

     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
    
                 let cell : GoalCell = tableView
                 .dequeueReusableCell (withIdentifier: "GoalCell", for: indexPath) as! GoalCell

                let g = goalList[indexPath.row]
        cell.goalTitle.text = g.goalTitle;
        cell.percentageLabel.text = "80%"
        cell.duration.text = "\(g.duration) "

        cell.dateRange.text = "\(g.date)"
        cell.progressView.setProgress(8, animated: false)
        
        cell.progressView.transform = cell.progressView.transform.scaledBy(x: 1, y: 15)
    
         print("heloo world")

                 return cell
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
