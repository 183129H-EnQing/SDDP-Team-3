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
    var goalList : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goalList.append(Post(
           userName: "Paul",
           pcontent: "Keep Fit",
           pdatetime: "5.34PM",
           userLocation:"YISHUN",
           pimageName:  "thumbnail_images"))
        // Do any additional setup after loading the view.
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return 1

     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
    
                 let cell : GoalCell = tableView
                 .dequeueReusableCell (withIdentifier: "GoalCell", for: indexPath) as! GoalCell

                let p = goalList[indexPath.row]
                          cell.goalTitle.text = p.userName
        cell.percentageLabel.text = "80%"
        cell.duration.text = "\(p.pcontent) "
                          cell.dateRange.text = "\(p.userLocation)"
        
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
