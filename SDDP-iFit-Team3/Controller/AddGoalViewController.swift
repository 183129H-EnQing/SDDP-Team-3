//
//  AddGoalViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 7/2/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let activityNamesPickerData = ["Running","Push Up","Sit Up"];
    @IBOutlet weak var goalTitle: UITextField!
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var datePicker: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var totalExerciseAmount: UITextField!
    
    weak var activityNamepickerView: UIPickerView?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        let pickerView = UIPickerView()
   
        pickerView.delegate = self
        activityName.inputView = pickerView
        
    }
    
    // MARK: UIPickerView Delegation

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityNamesPickerData.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityNamesPickerData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activityName.text = activityNamesPickerData[row]
    }
    
    @IBAction func addGoalPressed(_ sender: Any) {
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
