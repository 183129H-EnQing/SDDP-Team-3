//
//  TrainingPlanAddExerciseViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class TrainingPlanAddExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var exerciseList : [String] = []
    var filterList: [String] = []
    
    var tickExercise: [String] = []
    
    var exisitTP: Bool = false
    var existingTPExercise: [String]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exerciseList = ["Plank on forearms", "Elevated crunches", "Push-up", "Sit-up"]
        filterList = exerciseList
        
        if existingTPExercise != nil {
            exisitTP = true
            tickExercise = existingTPExercise!
            print("ticked ", tickExercise)
            
            for i in 0..<filterList.count {
                for j in 0..<existingTPExercise!.count {
                    
                    if filterList[i] == existingTPExercise![j]{
                        let indexPath = IndexPath(row: i, section: 0)
                        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
                        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    }
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPExerciseCell", for: indexPath)
        let e = filterList[indexPath.row]
        cell.textLabel?.text = e
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        print("tick checking")
        if (tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            tickExercise.append(filterList[indexPath.row])
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            
            if var index = tickExercise.firstIndex(of: filterList[indexPath.row]){
                tickExercise.remove(at: index)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterList = []
        
        if searchText == "" {
            filterList = exerciseList
        }
        else {
            for e in exerciseList {
                if e.lowercased().contains(searchText.lowercased()) {
                    filterList.append(e)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func requestData(data: String, completionHandler: (_ success: Bool) -> Void){
        
        completionHandler(true)
    }

    
    @IBAction func addExercisePressed(_ sender: Any) {
//        print(tickExercise)
        
        
        let viewControllers = self.navigationController?.viewControllers
        print("ViewControllers length: \(viewControllers!.count)")
        
        
        var addTPVC: TrainingPlanAddViewController
        
        if exisitTP == true {
            addTPVC = viewControllers![1] as! TrainingPlanAddViewController
        }
        else{
            addTPVC = viewControllers![1] as! TrainingPlanAddViewController
        }
        
        //let addTPVC = self.storyboard?.instantiateViewController(withIdentifier: "TrainingPlanAddVC") as! TrainingPlanAddViewController
        
        addTPVC.requestExercise{ (success) in

            if success{
                addTPVC.exerciseListFrom = tickExercise
                print("success transfer", addTPVC.exerciseListFrom)
                addTPVC.tableView.reloadData()
            }
        }
        
        addTPVC.exerciseListFrom = tickExercise
        addTPVC.viewWillAppear(true)
        
//        addTPVC.tableView.reloadData()
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
        
//        self.navigationController?.pushViewController(addTPVC, animated: true)
//        self.present(addTPVC, animated: true, completion: nil)
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
