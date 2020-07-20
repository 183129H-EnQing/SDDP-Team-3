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

        self.navigationItem.title = "Training Plan"
        
        let viewExercise = UIBarButtonItem(title: "Library", style: UIBarButtonItem.Style.plain, target: self, action: #selector(viewExerciseLibrary))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(changeView))
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain , target: self, action: #selector(enableEdit))
        
        self.navigationItem.leftBarButtonItem = viewExercise
        self.navigationItem.rightBarButtonItems = [addButton, editButton]
//        self.navigationItem.rightBarButtonItem = addButton
            
//        self.trainingPlanList = [
//            TrainingPlan(id: "", userId: "", tpName: "Hello Monday", tpDesc: "for monday morning", tpReps: 10, tpExercises: ["Jumping Jack", "Sit-Up"], tpImage: "pull_string"),
//            TrainingPlan(id: "", userId: "", tpName: "Welcome Friday", tpDesc: "friday evening", tpReps: 20, tpExercises: ["Plank on forearms"], tpImage: "step_string")]
        
        loadTrainingPlan()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTrainingPlan()
        tableView.reloadData()
    }
    
    func loadTrainingPlan(){
        if let user = UserAuthentication.getLoggedInUser() {
            DataManager.TrainingPlanClass.loadTrainingPlan(userId: user.uid) { (data) in
                
                if data.count > 0 {
                    self.trainingPlanList = data
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func viewExerciseLibrary(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Fitness", bundle: Bundle.main)
        let exerciseVC = storyBoard.instantiateViewController(withIdentifier: "ExerciseVC") as! ExerciseViewController
        
        navigationController?.pushViewController(exerciseVC, animated: true)
        
        //modal
        //        self.present(addVC, animated: true, completion: nil)
    }
    
    @objc func changeView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Fitness", bundle: Bundle.main)
        let addVC = storyBoard.instantiateViewController(withIdentifier: "TrainingPlanAddVC") as! TrainingPlanAddViewController
        
        navigationController?.pushViewController(addVC, animated: true)
        
        //modal
//        self.present(addVC, animated: true, completion: nil)
    }
    
    @objc func enableEdit(){
        if !self.tableView.isEditing
        {
            
//            sender.setTitle("Done", for: .normal)
            tableView.setEditing(true, animated: true)
        }
        else
        {
//            sender.setTitle("Edit", for: .normal)
            tableView.setEditing(false, animated: true)
        }
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
        //        cell.trainingPlanImageView.image = UIImage(named: t.tpImage)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: NSURL(string: t.tpImage)! as URL) {
//                print("HIIII\(data)")
                DispatchQueue.main.async {
                    cell.trainingPlanImageView.image = UIImage(data: data)
                }
            }
        }
        
        
        return cell
    }
    
    // delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let user = UserAuthentication.getLoggedInUser() {
                DataManager.TrainingPlanClass.deleteTrainingPlan(userId: user.uid, trainingPlan: self.trainingPlanList[indexPath.row], onComplete: { (isSuccess) in
                    
                    if isSuccess {
                        self.loadTrainingPlan()
                    } else {
                        self.present(Team3Helper.makeAlert("Unavailable to delete to Training Plan!"), animated: true)
                    }
                })
            }
        }
    }

    //pass data to details page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ShowTrainingPlanDetails"){
            let detailVC = segue.destination as! TrainingPlanDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            
            if (myIndexPath != nil){
                let trainItem = trainingPlanList[myIndexPath!.row]
                detailVC.trainingPlanItem = trainItem
            }
        }
    }
    
//    //delete
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if (editingStyle == .delete){
//            trainingPlanList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
    //reorder
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let t = trainingPlanList[sourceIndexPath.row]
        trainingPlanList.remove(at: sourceIndexPath.row)
        trainingPlanList.insert(t, at: destinationIndexPath.row)
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
