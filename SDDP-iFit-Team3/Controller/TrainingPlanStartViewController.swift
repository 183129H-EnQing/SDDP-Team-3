//
//  TrainingPlanStartViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 13/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import Fritz

class TrainingPlanStartViewController: UIViewController {
    
    let poseModel = FritzVisionPoseModelOptions()
    
    // We can also set of sensitivity parameters for our model.
    // The poseThreshold is a number between 0 and 1. Higher numbers mean
    // the model must be more confident about its estimate, thus reducing false
    // positives.
    internal var poseThreshold: Double = 0.3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
