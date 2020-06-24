//
//  TrainingPlanViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 6/23/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class TrainingPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    var trainingPlanList: [TrainingPlan] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.trainingPlanList = [ TrainingPlan(tpName: "Hello Monday", tpImage: "pull_string"),  TrainingPlan(tpName: "Welcome Friday", tpImage: "step_string")]
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trainingPlanList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingPlanCell", for: indexPath)
//        let t = trainingPlanList[indexPath.row]
//        cell.textLabel?.text = t
        
        let cell: TrainingPlanCell = tableView.dequeueReusableCell(withIdentifier: "TrainingPlanCell", for: indexPath) as! TrainingPlanCell
        let t = trainingPlanList[indexPath.row]
        cell.nameLabel.text = t.tpName
        cell.trainingPlanImageView.image = UIImage(named: t.tpImage)
        
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
