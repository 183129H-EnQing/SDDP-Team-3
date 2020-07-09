//
//  AddPostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import os.log
import CoreLocation
import FirebaseStorage

class AddPostViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var takepicture: UIButton!
    
    @IBOutlet weak var selectpicture: UIButton!
    
    @IBOutlet weak var addbutton: UIButton!
    
    @IBOutlet weak var loctext: UILabel!
    
    @IBOutlet weak var contenttext: UITextField!
    
    @IBOutlet weak var dateText: UILabel!
    
    var image: UIImage? = nil
    
    var postItem : Post?
    var locationManager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //contenttext.delegate = self
        //updateSaveButtonState()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
    }
   
    
    @IBAction func takePicturePressed(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .camera
        self.present(picker, animated: true)
        
    }
    
    
    @IBAction func selectPcturepressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

      

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                
            
                 self.loctext.text = "\(placemark.locality!)"
                
            }
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
          // super.prepare(for: segue, sender: sender)
           
        
            
//guard let button = sender as? UIButton, button === addbutton else {
               //os_log("The add button was not pressed, cancelling", log: OSLog.default, type: .debug)
              // return
          // }
        
        
       // let content = contenttext.text ?? ""
        
        //let date = Date()
       // let formatter = DateFormatter()
        //formatter.dateFormat = "MMM d, h:mm a"
       // let  datetime = formatter.string(from: date)
        
        
        
       /// let loca = loctext.text!
            
        
    
        

        
        //let photo = imageview.image
        
     
      //  postItem = Post(userName: "Dinesh", pcontent: content, pdatetime: datetime, userLocation:loca, pimageName: "img" , commentPost: [ ] )
        
         
        
   // }
    
    
   
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = contenttext.text ?? ""
        addbutton.isEnabled = !text.isEmpty
    }
  
    
    @IBAction func addbuttonpressed(_ sender: Any) {
        
       // let content = contenttext.text!
        
         //Team3Helper.colorTextFieldBorder(textField: contenttext, isRed: false)
        // if content == "" {
                  // Team3Helper.colorTextFieldBorder(textField: contenttext, isRed: true)
                   //self.present(Team3Helper.makeAlert("Content is Empty!!!"), animated: true)
                  // return
        if let user = UserAuthentication.getLoggedInUser(){
            
            guard let choosenImage = self.image else{
                print("Postimage is nil")
                return
            }
            
            guard let imageData = choosenImage.jpegData(compressionQuality: 0.5)else{
                return
            }
            let content = contenttext.text ?? ""
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, h:mm a"
                let  datetime = formatter.string(from: date)
                
                
                
              let loca = loctext.text ?? ""
             print(loca)

              let viewControllers = self.navigationController?.viewControllers
              
              let parent = viewControllers?[1] as! PostViewController

                
                //let photo = imageview.image
                
             
                postItem = Post(userName: "Dinesh", pcontent: content, pdatetime: datetime, userLocation:loca, pimageName: "" , commentPost: [ ] )
        
                        DataManager.Posts.insertPost(userId:user.uid,postItem!) { (isSuccess) in
                                    self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
           
            }
                
    }
    }
        
        
    func afterDbOperation(parent: PostViewController, isSuccess: Bool, isUpdating: Bool) {
        if !isSuccess {
            let mode = isUpdating ? "updating the" : "adding a"
            self.present(Team3Helper.makeAlert("Wasn't successful in \(mode) post"), animated: true)
        }
        
        parent.loadPosts()
        self.navigationController?.popViewController(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
    [UIImagePickerController.InfoKey : Any])
    {
            let chosenImage : UIImage =
            info[.editedImage] as! UIImage
            self.imageview!.image = chosenImage
        
            image = chosenImage
            // This saves the image selected / shot by the user
            //
            UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)

            // This closes the picker //
            picker.dismiss(animated: true)
                
            }
            
            func imagePickerControllerDidCancel(
                _ picker: UIImagePickerController)
            {
                picker.dismiss(animated: true)
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
