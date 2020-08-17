//
//  AddScheduleViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class SchedulerDetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var hrsTextField: UITextField!
    @IBOutlet weak var minsTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var currentTextFieldPicker: String = ""
    
    var exercisePicker: UIPickerView = UIPickerView()
    var dayPicker: UIPickerView = UIPickerView()
    var exercises: [Exercise] = []
    var selectedExercise = -1
    var selectedDay = -1
    
    var schedule: Schedule?
    var userSchedules: [Int: [Schedule]] = [:]
    
    static var days: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] // because date component's weekDay starts from sunday, monday... and end with saturday
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exerciseTextField.delegate = self
        self.dayTextField.delegate = self
        
        self.exercisePicker.delegate = self
        self.exercisePicker.dataSource = self
        self.dayPicker.delegate = self
        self.dayPicker.dataSource = self
        
        self.exerciseTextField.inputView = self.exercisePicker
        self.dayTextField.inputView = self.dayPicker
        
        givePickerBarButton(exerciseTextField)
        givePickerBarButton(dayTextField)

        // Do any additional setup after loading the view.
        self.timePicker.layer.borderWidth = 1
        self.timePicker.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var title = "Add Schedule"
        if let unwrapSchedule = self.schedule {
            title = "Edit Schedule"

            // After loading exercises, then fill up exercises picker and text field
            self.loadExercises {
                for exerciseIndex in 0..<self.exercises.count {
                    if self.exercises[exerciseIndex].exName == unwrapSchedule.exerciseName {
                        self.exercisePicker.selectRow(exerciseIndex, inComponent: 0, animated: true)
                        self.exerciseTextField.text = self.exercises[exerciseIndex].exName
                        self.selectedExercise = exerciseIndex
                        break
                    }
                }
            }
            
            self.dayPicker.selectRow(unwrapSchedule.day, inComponent: 0, animated: true)
            self.dayTextField.text = SchedulerDetailsViewController.days[unwrapSchedule.day]
            self.selectedDay = unwrapSchedule.day
            
            self.hrsTextField.text = "\(unwrapSchedule.duration[0])"
            self.minsTextField.text = "\(unwrapSchedule.duration[1])"
            
            // set default time: https://stackoverflow.com/a/28986143
            let calender = Calendar.current
            var components = calender.dateComponents([.hour, .minute], from: Date())
            components.hour = unwrapSchedule.time[0]
            components.minute = unwrapSchedule.time[1]
            self.timePicker.setDate(calender.date(from: components)!, animated: true)
        } else {
            self.loadExercises(nil)
        }
        
        self.navigationItem.title = title
    }
    
    // --- Start Picker methods ---
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == self.exercisePicker ? self.exercises.count : SchedulerDetailsViewController.days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == self.exercisePicker ? self.exercises[row].exName : SchedulerDetailsViewController.days[row]
    }
    
    // prevent any typing for exercise and day text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == exerciseTextField || textField == dayTextField {
            return false
        }
        return true
    }
    
    // change the currentTextFieldPicker string value
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == exerciseTextField {
            self.currentTextFieldPicker = "exercise"
        } else if textField == dayTextField {
            self.currentTextFieldPicker = "day"
        }
    }
    // --- End Picker methods ---

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let user = UserAuthentication.getLoggedInUser() {
            Team3Helper.colorTextFieldBorder(textField: exerciseTextField, isRed: false)
            Team3Helper.colorTextFieldBorder(textField: dayTextField, isRed: false)
            Team3Helper.colorTextFieldBorder(textField: hrsTextField, isRed: false)
            Team3Helper.colorTextFieldBorder(textField: minsTextField, isRed: false)
            
            if selectedExercise < 0 {
                Team3Helper.colorTextFieldBorder(textField: exerciseTextField, isRed: true)
                
                let alert = Team3Helper.makeAlert("Please select an exercise!")
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if selectedDay < 0 {
                Team3Helper.colorTextFieldBorder(textField: dayTextField, isRed: true)
                
                let alert = Team3Helper.makeAlert("Please select a day!")
                self.present(alert, animated: true, completion: nil)
                return
            }
            
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
            
            let day = dayPicker.selectedRow(inComponent: 0)
            let timeComp = timePicker.calendar.dateComponents([.hour, .minute], from: timePicker.date)
            let exercise = self.exercises[exercisePicker.selectedRow(inComponent: 0)].exName
            let duration = [hrs, mins]
            
            let viewControllers = self.navigationController?.viewControllers
            let parent = viewControllers?[0] as! SchedulerViewController
            
            // Schedule
            let newSchedule = Schedule(exerciseName: exercise, duration: duration, day: day, time: [timeComp.hour!, timeComp.minute!])
            // If not nil, is editing. Else if it is nil, is adding
            if self.schedule != nil {
                // Update
                newSchedule.id = self.schedule!.id!
                DataManager.Schedules.updateSchedule(schedule: newSchedule) { (isSuccess) in
                    self.makeNotification(exercise: exercise, timeComp: timeComp, day: day, duration: duration, scheduleId: newSchedule.id!, userId: user.uid)
                    self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: true)
                }
            } else {
                // Add
                DataManager.Schedules.insertSchedule(userId: user.uid, newSchedule) { (isSuccess, id) in
                    self.makeNotification(exercise: exercise, timeComp: timeComp, day: day, duration: duration, scheduleId: id!, userId: user.uid)
                    self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
                }
            }
        } else {
            self.present(Team3Helper.makeAlert("Please relog in!"), animated: true)
            Team3Helper.changeRootScreen(currentController: self, goToTabs: false, tookSurvey: false)
        }
    }
    
    // --- Custom Methods ---
    
    // timeComp contains the schedule's time
    func makeNotification(exercise: String, timeComp: DateComponents, day: Int, duration: [Int], scheduleId: String, userId: String) {
        // true date
        let actualDateComp = Calendar.current.dateComponents([.weekday, .hour, .minute], from: Date())
        
        // need to minus 1, cause weekDay starts is 1 to 7
        if (actualDateComp.weekday!-1) == day && (timeComp.hour! > actualDateComp.hour! || (timeComp.hour! == actualDateComp.hour! && timeComp.minute! > actualDateComp.minute!)) {
            print("going to add notification")
            Team3Helper.notificationCenter.getNotificationSettings { (settings) in
                let status = settings.authorizationStatus
                if status == .denied || status == .notDetermined {
                    self.present(Team3Helper.makeAlert("Couldn't add schedule, you need to enable notifications for this app!"), animated: true)
                    return
                }
                
                // Notification
                let timeMsg = (duration[0] > 0 ? "\(duration[0]) hrs" : "") + (duration[0] > 0 && duration[1] > 0 ? " " : "") + (duration[1] > 0 ? "\(duration[1]) mins" : "")
                let content = Team3Helper.createNotificationContent(title: "Scheduler", message: "\(exercise) - \(timeMsg)")
                
                var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
                dateComponents.hour = timeComp.hour
                dateComponents.minute = timeComp.minute
                
                print("making notification")
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                /* set the identifer for day, hour, minute. The scheduleId is for,*/
                Team3Helper.notificationCenter.add(UNNotificationRequest(identifier: "scheduler.\(scheduleId).\(userId)", content: content, trigger: trigger))
            }
        }
    }
      
    @objc func pickerDoneClick() {
        if self.currentTextFieldPicker == "exercise" {
            self.selectedExercise = exercisePicker.selectedRow(inComponent: 0)
            self.exerciseTextField.text = self.exercises[self.selectedExercise].exName
            self.exerciseTextField.resignFirstResponder()
        } else if self.currentTextFieldPicker == "day" {
            self.selectedDay = dayPicker.selectedRow(inComponent: 0)
            self.dayTextField.text = SchedulerDetailsViewController.days[self.selectedDay]
            self.dayTextField.resignFirstResponder()
        }
        self.currentTextFieldPicker = ""
    }
    @objc func pickerCancelClick() {
        if self.currentTextFieldPicker == "exercise" {
            if selectedExercise >= 0 {
                self.exercisePicker.selectRow(selectedExercise, inComponent: 0, animated: true)
            }
            self.exerciseTextField.resignFirstResponder()
        } else if self.currentTextFieldPicker == "day" {
            if selectedDay >= 0 {
                self.dayPicker.selectRow(selectedDay, inComponent: 0, animated: true)
            }
            self.dayTextField.resignFirstResponder()
        }
        self.currentTextFieldPicker = ""
    }
    
    func afterDbOperation(parent: SchedulerViewController, isSuccess: Bool, isUpdating: Bool) {
        if !isSuccess {
            let mode = isUpdating ? "updating the" : "adding a"
            self.present(Team3Helper.makeAlert("Wasn't successful in \(mode) schedule"), animated: true)
        }
        
        parent.loadSchedules()
        self.navigationController?.popViewController(animated: true)
    }
    
    func givePickerBarButton(_ textField: UITextField) {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func loadExercises(_ onComplete: (()-> Void)?) {
        self.exercises = []
        DataManager.ExerciseClass.loadExercises { (exercises) in
            self.exercises = exercises
            DispatchQueue.main.async {
                self.exercisePicker.reloadAllComponents()
                onComplete?()
            }
        }
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
