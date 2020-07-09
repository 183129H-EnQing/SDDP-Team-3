//
//  ExerciseDetailViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/9/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {

    
    var exerciseList: Exercise = Exercise(exName: "", exDesc: "", exImage: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
        self.navigationItem.title = exerciseList.exName
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
