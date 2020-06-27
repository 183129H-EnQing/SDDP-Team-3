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
        self.exercisePicker.layer.borderColor = UIColor.systemGray3.cgColor
        self.timePicker.layer.borderWidth = 1
        self.timePicker.layer.borderColor = UIColor.systemGray3.cgColor
        self.dayPicker.layer.borderWidth = 1
        self.dayPicker.layer.borderColor = UIColor.systemGray3.cgColor
        
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
        colorTextFieldBorder(textField: hrsTextField, isRed: false)
        colorTextFieldBorder(textField: minsTextField, isRed: false)
        
        if !Team3Helper.ifInputIsInt(someInput: hrsTextField.text!) || !Team3Helper.ifInputIsInt(someInput: hrsTextField.text!) {
            colorTextFieldBorder(textField: hrsTextField, isRed: true)
            colorTextFieldBorder(textField: minsTextField, isRed: true)
            
            let alert = Team3Helper.makeAlert("Only numbers allowed in 'Duration' text fields")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let hrs = Int(hrsTextField.text!)!
        let mins = Int(minsTextField.text!)!
        
        if hrs > 24 || hrs < 0 {
            colorTextFieldBorder(textField: hrsTextField, isRed: true)
            
            let alert = Team3Helper.makeAlert("Hours can only be between 0 and 24")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if mins > 59 || mins < 0 {
            colorTextFieldBorder(textField: minsTextField, isRed: true)
            
            let alert = Team3Helper.makeAlert("Mins can only be between 0 and 59")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if hrs == 0 && mins == 0 {
            colorTextFieldBorder(textField: hrsTextField, isRed: true)
            colorTextFieldBorder(textField: minsTextField, isRed: true)
            
            let alert = Team3Helper.makeAlert("Duration cannot be 0")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let exercise = exercises[exercisePicker.selectedRow(inComponent: 0)]
        let time = timePicker.calendar.dateComponents([.hour, .minute], from: timePicker.date)
        let day = dayPicker.selectedRow(inComponent: 0)
        
        let viewControllers = self.navigationController?.viewControllers
        let parent = viewControllers?[0] as! SchedulerViewController
        parent.testData.append(Schedule(name: exercise, duration: [hrs, mins], day: day, time: [time.hour!, time.minute!]))
        parent.tableView.reloadData()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func colorTextFieldBorder(textField: UITextField, isRed: Bool) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = isRed ? UIColor.systemRed.cgColor : UIColor.systemGray3.cgColor
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
