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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exerciseList = ["Plank on forearms", "Elevated crunches", "Push-up", "Sit-up"]
        filterList = exerciseList
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
        if (tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            tickExercise.append(exerciseList[indexPath.row])
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
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

    
    @IBAction func addExercisePressed(_ sender: Any) {
//        print(tickExercise)
        
        let addTPVC = self.storyboard?.instantiateViewController(withIdentifier: "TrainingPlanAddVC") as! TrainingPlanAddViewController
        
        addTPVC.exerciseListFrom = tickExercise
        
        dismiss(animated: true, completion: nil)
        
        
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
