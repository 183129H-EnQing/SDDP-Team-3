//
//  AddGoalViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 7/2/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

    let activityNamesPickerData = ["Running","Push Up","Sit Up"];
    @IBOutlet weak var goalTitle: UITextField!
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var datePicker: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var totalExerciseAmount: UITextField!
    
    weak var activityNamepickerView: UIPickerView?
    weak var chooseTextField: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textfield delegate
        goalTitle.delegate = self
        duration.delegate = self
        datePicker.delegate = self
        activityName.delegate = self
        totalExerciseAmount.delegate = self
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        // allow textfield to have picker inside it
        activityName.inputView = pickerView
        
        // setting min and max date to control the datepicker
         var components = DateComponents()
           components.year = 0
           let minDate = Calendar.current.date(byAdding: components, to: Date())

           components.year = 1
           let maxDate = Calendar.current.date(byAdding: components, to: Date())

        let datePickerView = UIDatePicker()
           datePickerView.datePickerMode = .date
        
           datePickerView.minimumDate = minDate
           datePickerView.maximumDate = maxDate
        
           datePicker.inputView = datePickerView
       
        // call function when user pick date
      datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        // default value inside the picker
        activityName.text = activityNamesPickerData[0]
         
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let result = formatter.string(from: date)
        datePicker.text = result
     
      
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "dd MMM yyyy"
        
               datePicker.text = dateFormatter.string(from: sender.date)
           }
    
    // Control what inside the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // string value - user key in value
      if(textField == duration){
         let currentText = textField.text! + string

         return currentText.count <= 3
      }
    
       if (textField == datePicker){
            return false // means user cannot type anything
        }
        if(textField == activityName){
            return false
        }
      return true;
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

     func textFieldDidBeginEditing(_ textField: UITextField) {

        self.pickUp(textField)
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
    
    func pickUp(_ textField : UITextField){
        self.chooseTextField = textField;
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar

     }
    
   @objc func doneClick() {
    // activityName.resignFirstResponder() -> for only for text field that need to be cancel or done with keyboard/picker
    self.chooseTextField!.resignFirstResponder()
     }
   @objc func cancelClick() {
    self.chooseTextField!.resignFirstResponder()
    }
}
