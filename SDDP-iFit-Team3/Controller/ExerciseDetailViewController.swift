//
//  ExerciseDetailViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/9/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    var exerciseList: Exercise = Exercise(exName: "", exDesc: "", exImage: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
        self.navigationItem.title = exerciseList.exName
        
        imageView.image = UIImage(named: exerciseList.exImage)
        nameLabel.text = exerciseList.exName
        descLabel.text = exerciseList.exDesc
        repsLabel.text = "10"
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
