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
    
    @IBOutlet weak var addPlan: UIButton!
    var exisitngTP: TrainingPlan?
    var existTP: Bool = false
    
    var newTrainingPlan : TrainingPlan?
    var exerciseListFrom : [String] = ["he"]
    
    var uploadImage: UIImage?
//    var uploadImageUUID: String?
    
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
        
        if exisitngTP != nil {
            titleLabel.text = exisitngTP?.tpName
            descLabel.text = exisitngTP?.tpDesc
            repsLabel.text = "\(exisitngTP!.tpReps)"
//            imageView.image = UIImage(named: exisitngTP!.tpImage)
            exerciseListFrom = exisitngTP!.tpExercises
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: NSURL(string: self.exisitngTP!.tpImage)! as URL) {
                    print("HIIII\(data)")
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
            
            addPlan.setTitle("Update Plan", for: .normal)
            
            existTP = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        print("HIIII", exerciseListFrom)
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
        // the image to a square after the image is selected. // picker.allowsEditing = true¸
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImage: UIImage = info[.originalImage] as! UIImage
        self.imageView!.image = chosenImage
        
        self.uploadImage = chosenImage
        
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
        
        if validateInput() == false && self.exisitngTP == nil{
            
            if self.uploadImage != nil {
                StorageManager.uploadTrainingPlanImage(userId: "oPzKpyctwUTgC9cYBq6OYoNqpZ62", image: self.uploadImage!) { url in
                    if let url = url {
                        
//                        let imageName = NSUUID().uuidString
//                        self.uploadImageUUID = imageName
                        
                        print("hiii \(url)")
                        
                        self.newTrainingPlan = TrainingPlan(id: "", userId: "oPzKpyctwUTgC9cYBq6OYoNqpZ62", tpName: self.titleLabel.text!, tpDesc: self.descLabel.text!, tpReps: Int(self.repsLabel.text!)!, tpExercises: self.exerciseListFrom, tpImage: "\(url)")
                        
                        if let user = UserAuthentication.getLoggedInUser() {
                            DataManager.TrainingPlanClass.insertTrainingPlan(_userId: user.uid, trainingPlan: self.newTrainingPlan!, onComplete: nil)
                            

                            self.navigationController?.popViewController(animated: true)
                            self.navigationController?.viewControllers[0].present(Team3Helper.makeAlert("New Training Plan added!"), animated: true)
                        }
                    }
                    
                }
            }
        }
        else if validateInput() == false && self.exisitngTP != nil {
            
            if self.uploadImage != nil {    //if user upload new photo
                StorageManager.uploadTrainingPlanImage(userId: "oPzKpyctwUTgC9cYBq6OYoNqpZ62", image: self.uploadImage!) { url in
                    if let url = url {
                        self.exisitngTP!.tpImage = "\(url)"
                        
                        self.addUpdateTP()
                    }
                }
            }
            else {      //if no photo was uploaded
                addUpdateTP()
            }
        }
    }
    
    func addUpdateTP(){
        //update fields to existingTP
        self.exisitngTP!.tpName = self.titleLabel.text!
        //            print(self.exisitngTP!.tpName)
        self.exisitngTP!.tpDesc = self.descLabel.text!
        self.exisitngTP!.tpReps = Int(self.repsLabel.text!)!
        self.exisitngTP!.tpExercises = self.exerciseListFrom
        //                imageView.image = UIImage(named: exisitngTP!.tpImage)
        //                self.exisitngTP!.tpExercises = exerciseListFrom
        
        //update exisitng TP in firebase
        if let user = UserAuthentication.getLoggedInUser() {
            DataManager.TrainingPlanClass.updateTrainingPlan(userId: user.uid, trainingPlan: self.exisitngTP!) { (success) in
                
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.viewControllers[1].viewWillAppear(true)
                self.navigationController?.viewControllers[0].viewWillAppear(true)
                self.navigationController?.viewControllers[1].present(Team3Helper.makeAlert("Existing Training Plan updated!"), animated: true)
            }
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
    
    //pass data to exeercise page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ShowExercises"){
            let exVC = segue.destination as! TrainingPlanAddExerciseViewController
            
            let exItem = exisitngTP?.tpExercises
            exVC.existingTPExercise = exItem
            
        }
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
