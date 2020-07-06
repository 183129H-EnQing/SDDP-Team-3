//
//  TrainingPlanDetailViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 6/23/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class TrainingPlanDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var trainingPlanImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var trainingPlanItem : TrainingPlan?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain , target: self, action: #selector(enableEdit))
        self.navigationItem.rightBarButtonItems = [editButton]

        // Do any additional setup after loading the view.
        self.navigationItem.title = trainingPlanItem?.tpName
        trainingPlanImage.image = UIImage(named: (trainingPlanItem?.tpImage)!)
        nameLabel.text = trainingPlanItem?.tpName
        descLabel.text = trainingPlanItem?.tpDesc
        repsLabel.text = "\(trainingPlanItem!.tpReps)"
        //exercises not added
    }
    
    @objc func enableEdit(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Fitness", bundle: Bundle.main)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "TrainingPlanAddVC") as! TrainingPlanAddViewController
        
        editVC.exisitngTP = trainingPlanItem
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (trainingPlanItem?.tpExercises.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPExercise", for: indexPath)
        let t = trainingPlanItem?.tpExercises[indexPath.row]
        cell.textLabel?.text = t
        
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
