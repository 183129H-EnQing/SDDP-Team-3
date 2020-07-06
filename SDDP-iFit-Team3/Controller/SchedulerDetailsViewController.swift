//
//  AddScheduleViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class SchedulerDetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBOutlet weak var hrsTextField: UITextField!
    @IBOutlet weak var minsTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var dayPicker: UIPickerView!
    
    var schedule: Schedule?
    var scheduleIndex: Int?
    
    static var exercises: [String] = ["Push Up", "Jumping Jacks", "Skipping Rope", "Sit Up"]
    static var days: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.exercisePicker.layer.borderWidth = 1
        self.exercisePicker.layer.borderColor = UIColor.systemGray3.cgColor
        self.timePicker.layer.borderWidth = 1
        self.timePicker.layer.borderColor = UIColor.systemGray3.cgColor
        self.dayPicker.layer.borderWidth = 1
        self.dayPicker.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let unwrapSchedule = self.schedule {
            self.exercisePicker.selectRow(unwrapSchedule.exerciseId, inComponent: 0, animated: true)
            
            self.hrsTextField.text = "\(unwrapSchedule.duration[0])"
            self.minsTextField.text = "\(unwrapSchedule.duration[1])"
            
            // set default time: https://stackoverflow.com/a/28986143
            let calender = Calendar.current
            var components = calender.dateComponents([.hour, .minute], from: Date())
            components.hour = unwrapSchedule.time[0]
            components.minute = unwrapSchedule.time[1]
            self.timePicker.setDate(calender.date(from: components)!, animated: true)
            
            self.dayPicker.selectRow(unwrapSchedule.day, inComponent: 0, animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == self.exercisePicker.tag ? SchedulerDetailsViewController.exercises.count : SchedulerDetailsViewController.days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == self.exercisePicker.tag ? SchedulerDetailsViewController.exercises[row] : SchedulerDetailsViewController.days[row]
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let user = UserAuthentication.getLoggedInUser() {
            Team3Helper.colorTextFieldBorder(textField: hrsTextField, isRed: false)
            Team3Helper.colorTextFieldBorder(textField: minsTextField, isRed: false)
            
            if !Team3Helper.ifInputIsInt(someInput: hrsTextField.text!) || !Team3Helper.ifInputIsInt(someInput: minsTextField.text!) {
                Team3Helper.colorTextFieldBorder(textField: hrsTextField, isRed: true)
                Team3Helper.colorTextFieldBorder(textField: minsTextField, isRed: true)
                
                let alert = Team3Helper.makeAlert("Only numbers allowed in 'Duration' text fields")
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            let hrs = Int(hrsTextField.text!)!
            let mins = Int(minsTextField.text!)!
            
            if hrs > 24 || hrs < 0 {
                Team3Helper.colorTextFieldBorder(textField: hrsTextField, isRed: true)
                
                let alert = Team3Helper.makeAlert("Hours can only be between 0 and 24")
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if mins > 59 || mins < 0 {
                Team3Helper.colorTextFieldBorder(textField: minsTextField, isRed: true)
                
                let alert = Team3Helper.makeAlert("Mins can only be between 0 and 59")
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if hrs == 0 && mins == 0 {
                Team3Helper.colorTextFieldBorder(textField: hrsTextField, isRed: true)
                Team3Helper.colorTextFieldBorder(textField: minsTextField, isRed: true)
                
                let alert = Team3Helper.makeAlert("Duration cannot be 0")
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            let exercise = exercisePicker.selectedRow(inComponent: 0)
            let time = timePicker.calendar.dateComponents([.hour, .minute], from: timePicker.date)
            let day = dayPicker.selectedRow(inComponent: 0)
            
            let viewControllers = self.navigationController?.viewControllers
            let parent = viewControllers?[0] as! SchedulerViewController
            
            let newSchedule = Schedule(exerciseId: exercise, duration: [hrs, mins], day: day, time: [time.hour!, time.minute!])
            // If not nil, is editing. Else if it is nil, is adding
            if self.schedule != nil {
                // Update
                newSchedule.id = self.schedule!.id!
                DataManager.Schedules.updateSchedule(schedule: newSchedule) { (isSuccess) in
                    self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: true)
                }
            } else {
                // Add
                DataManager.Schedules.insertSchedule(userId: user.uid, newSchedule) { (isSuccess) in
                    self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
                }
            }
        } else {
            self.present(Team3Helper.makeAlert("Please relog in!"), animated: true)
            Team3Helper.changeRootScreen(currentController: self, goToTabs: false)
        }
    }
    
    func afterDbOperation(parent: SchedulerViewController, isSuccess: Bool, isUpdating: Bool) {
        if !isSuccess {
            let mode = isUpdating ? "updating the" : "adding a"
            self.present(Team3Helper.makeAlert("Wasn't successful in \(mode) schedule"), animated: true)
        }
        
        parent.loadSchedules()
        self.navigationController?.popViewController(animated: true)
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
