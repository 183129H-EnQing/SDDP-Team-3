//
//  TrainingPlanDetailViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 6/23/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class TrainingPlanDetailViewController: UIViewController {

    @IBOutlet weak var trainingPlanImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    var trainingPlanItem : TrainingPlan?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trainingPlanImage.image = UIImage(named: (trainingPlanItem?.tpImage)!)
        nameLabel.text = trainingPlanItem?.tpName
       
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
