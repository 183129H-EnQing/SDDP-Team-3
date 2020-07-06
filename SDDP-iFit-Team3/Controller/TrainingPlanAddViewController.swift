//
//  TrainingPlanAddViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class TrainingPlanAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var selectPicture: UIButton!
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descLabel: UITextField!
    @IBOutlet weak var repsLabel: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var newTrainingPlan : TrainingPlan
    var exerciseListFrom : [String] = ["he"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // We check if this device has a camera
        //
        if !(UIImagePickerController.isSourceTypeAvailable( .camera))
        {
            // If not, we will just hide the takePicture button //
            takePicture.isHidden = true
        }
    }
    @IBAction func takePicturePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        // Setting this to true allows the user to crop and scale
        // the image to a square after the photo is taken. //
        picker.allowsEditing = true
        picker.sourceType = .camera
        
        self.present(picker, animated: true)
    }
    
    @IBAction func selectPicturePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        // Setting this to true allows the user to crop and scale
        // the image to a square after the image is selected. // picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImage : UIImage = info[.editedImage] as! UIImage
        self.imageView!.image = chosenImage
        
        // This saves the image selected / shot by the user
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)
        
        // This closes the picker //
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(
    _ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseListFrom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPShowTickExerciseCell", for: indexPath)
        let t = exerciseListFrom[indexPath.row]
        cell.textLabel?.text = t
        
        return cell
    }
    
    @IBAction func addTrainingPressed(_ sender: Any) {
//        newTrainingPlan = [TrainingPlan(tpName: titleLabel.text!, tpDesc: descLabel.text!, tpReps: Int(repsLabel.text!)!, tpExercises: [""], tpImage: "")]
        
        //to add newTrainingPlan object to data
        //to verify exerciseList in addExerciseVC
        
        if validateInput() == false{
//            newTrainingPlan = [titleLabel.text!, descLabel.text!, repsLabel.text!]
            newTrainingPlan = TrainingPlan(tpName: titleLabel.text!, tpDesc: descLabel.text!, tpReps: Int(repsLabel.text!)!, tpExercises: exerciseListFrom, tpImage: "")
            print(newTrainingPlan)
            
            let alert = Team3Helper.makeAlert("New Training Plan added!")
            self.present(alert, animated: true, completion: nil)
            
            DataManager.TrainingPlans.insertTrainingPlan(userId: "oPzKpyctwUTgC9cYBq6OYoNqpZ62", newTrainingPlan, onComplete: nil)
            
        }
        
        
    }
    
    func requestExercise(_ completionHandler: (_ success: Bool) -> Void) {
        
        completionHandler(true)
        
    }
    
    func validateInput() -> Bool{
        var errors = false

        Team3Helper.colorTextFieldBorder(textField: titleLabel, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: descLabel, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: repsLabel, isRed: false)
        
        if titleLabel.text == "" {
            Team3Helper.colorTextFieldBorder(textField: titleLabel, isRed: true)
            
            errors = true
        }
        
        if descLabel.text == "" {
            Team3Helper.colorTextFieldBorder(textField: descLabel, isRed: true)
            
            errors = true
        }
        
        if repsLabel.text == ""{
            Team3Helper.colorTextFieldBorder(textField: repsLabel, isRed: true)
            
            errors = true
        }
        
        if errors == true {
            let alert = Team3Helper.makeAlert("Please fill in all fields!")
            self.present(alert, animated: true, completion: nil)
        }
        
        if !Team3Helper.ifInputIsInt(someInput: repsLabel.text!){
            Team3Helper.colorTextFieldBorder(textField: repsLabel, isRed: true)
            
            let alert = Team3Helper.makeAlert("Reps must be Integer!")
            self.present(alert, animated: true, completion: nil)
            
            errors = true
        }
        return errors
    }
    
    /*
    // MARK: - Navigations

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
