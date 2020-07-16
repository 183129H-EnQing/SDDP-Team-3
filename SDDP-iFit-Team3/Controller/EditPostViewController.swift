//
//  EditPostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/27/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import os.log
import CoreLocation
import FirebaseUI

class EditPostViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var textcontent: UITextField!
    
    @IBOutlet weak var postimage: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var takePicture: UIButton!
    
    
    @IBOutlet weak var seleectPicture: UIButton!
    
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    
    var postItem : Post?
    var locationManager:CLLocationManager!
    var userName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
          //self.navigationItem.rightBarButtonItem =
             // UIBarButtonItem(barButtonSystemItem: .save,
                              //target: self,
                              //action: #selector(saveButtonclicked))
              
        // Do any additional setup after loading the view.
         if let postss = postItem  {
               textcontent.text = postss.pcontent
               
               
               
           }
        
        getUserName()
        
    }
    // @objc func saveButtonclicked()
       //{
                

      // }
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    textcontent.text = postItem?.pcontent
    postimage.sd_setImage(with: URL(string : postItem!.pimageName))
        
    
        
    self.navigationItem.title = "Edit Post"
        
    }
    
   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
             // super.prepare(for: segue, sender: sender)
              
            
             // guard let button = sender as? UIButton, button === saveButton else {
                 // os_log("The add button was not pressed, cancelling", log: OSLog.default, type: .debug)
                 /// return
             // }
           
           
         //  let content = textcontent.text ?? ""
           // let date = Date()
          //  let formatter = DateFormatter()
          //  formatter.dateFormat = "MMM d, h:mm a"
           // let datetime = formatter.string(from: date)
        
        
        
           
           //let photo = String(postimage.image)
        
            //let pic = UIImage(named: photo)
           
        
          // postItem = Post(userName: "Dinesh", pcontent: content, pdatetime: datetime, userLocation: "yishun", pimageName: "img" , commentPost: [ ] )
           
     //  }
    
    
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
                   
                   
               
                    self.location.text = "\(placemark.locality!)"
                   
               }
           }

       }
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Error \(error)")
       }
    
    func getUserName() {
    
          //  self.noSchedulesLabel.isHidden = false
            
            if let user = UserAuthentication.getLoggedInUser() {
                print("User is logged in")
            
                DataManager.getUserData(userId: user.uid) { (data) in
                        if let user = data {
                            self.userName = user.username!
                           
                            print("data",data)
                            }
                        }
                    }
            }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
         if let user = UserAuthentication.getLoggedInUser(){
            
            let content = textcontent.text ?? ""
                  let date = Date()
                  let formatter = DateFormatter()
                 formatter.dateFormat = "MMM d, h:mm a"
                  let datetime = formatter.string(from: date)
            
       // let name = 
        
        let loca = location.text ?? ""
            
           
            let viewControllers = self.navigationController?.viewControllers
            let parent = viewControllers?[1] as! PostViewController
            
                 let storage = Storage.storage()
                 let storageRef = storage.reference()
                 let imageName = NSUUID().uuidString
                 
                
                     
                 let photoRef = storageRef.child("\(imageName)")
                 
                     guard let imageData = self.postimage.image?.jpegData(compressionQuality: 0.1) else {
                     return
                 }
                 
                 
                 let metadata = StorageMetadata()
                 metadata.contentType = "image/jpg"
                 photoRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
                     if error != nil {
                         print(error?.localizedDescription)
                         return
                     }
                photoRef.downloadURL (completion: { (url, error) in
                if let metaImageUrl = url?.absoluteString{
                    //print(metaImageUrl)
                    let photo = metaImageUrl
                    let name = self.userName
                    let  posts = Post(userName: name, pcontent: content, pdatetime: datetime, userLocation: loca, pimageName: photo ,opened:false , commentPost: [ ] )
        
                    if self.postItem != nil {
                       // Update
                       posts.id = self.postItem!.id!
                       DataManager.Posts.updatePost(post: posts) { (isSuccess) in
                           self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: true)
                       }
                   } else {
                       // Add
                       DataManager.Posts.insertPost(userId:user.uid,posts) { (isSuccess) in
                                          self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
                                  
                              }
                   }
                 }
                 })
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
    
    @IBAction func takepicture(_ sender: Any) {
         let picker = UIImagePickerController()
               picker.delegate = self
               
               picker.allowsEditing = true
               picker.sourceType = .camera
               self.present(picker, animated: true)
    }
    
    
    @IBAction func selectpicture(_ sender: Any) {
        
        
         let picker = UIImagePickerController()
               picker.delegate = self
               
               picker.allowsEditing = true
               picker.sourceType = .photoLibrary
               self.present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
    [UIImagePickerController.InfoKey : Any])
    {
            let chosenImage : UIImage =
            info[.editedImage] as! UIImage
            self.postimage!.image = chosenImage
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
