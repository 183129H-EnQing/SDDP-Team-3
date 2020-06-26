//
//  AddScheduleViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class AddScheduleViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBOutlet weak var hrsTextField: UITextField!
    @IBOutlet weak var minsTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var dayPicker: UIPickerView!
    
    var exercises: [String] = []
    var days: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.exercises = ["Push Up", "Jumping Jacks", "Skipping Rope", "Sit Up"]
        
        self.exercisePicker.layer.borderWidth = 1
        self.exercisePicker.layer.borderColor = UIColor.systemGray2.cgColor
        self.timePicker.layer.borderWidth = 1
        self.timePicker.layer.borderColor = UIColor.systemGray2.cgColor
        self.dayPicker.layer.borderWidth = 1
        self.dayPicker.layer.borderColor = UIColor.systemGray2.cgColor
        
        self.days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == self.exercisePicker.tag ? self.exercises.count : self.days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == self.exercisePicker.tag ? exercises[row] : self.days[row]
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
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
