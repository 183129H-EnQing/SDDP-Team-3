//
//  EditPersonalViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 20/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseUI

class EditPersonalViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    
  
    
    @IBOutlet weak var location: UILabel!
    
    
    @IBOutlet weak var camera: UIButton!
    
    
    @IBOutlet weak var gallery: UIButton!
    
    
    @IBOutlet weak var save: UIButton!
    
    
    @IBOutlet weak var content: UITextField!
    
    @IBOutlet weak var pic: UIImageView!
    
    var postItem : Post?
     var userName : String = ""
    var locationManager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            
        }
        
        if let postss = postItem  {
               content.text = postss.pcontent
               
               
               
           }
        
        getUserName()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    content.text = postItem?.pcontent
    pic.sd_setImage(with: URL(string : postItem!.pimageName))
        
    
        
    self.navigationItem.title = "Edit Posts"
        
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        
         let picker = UIImagePickerController()
                      picker.delegate = self
                      
                      picker.allowsEditing = true
                      picker.sourceType = .camera
                      self.present(picker, animated: true)
        
    }
    
    
    @IBAction func gallerypressed(_ sender: Any) {
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
            self.pic!.image = chosenImage
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
    
    @IBAction func savebuttonPressed(_ sender: Any) {
        
        if let user = UserAuthentication.getLoggedInUser(){
             
             let ccontent = content.text ?? ""
                   let date = Date()
                   let formatter = DateFormatter()
                  formatter.dateFormat = "MMM d, h:mm a"
                   let datetime = formatter.string(from: date)
             
        // let name =
         
         Team3Helper.colorTextFieldBorder(textField: content, isRed: false)
         if content.text == ""{
                   Team3Helper.colorTextFieldBorder(textField: content, isRed: true)
                   let alert = Team3Helper.makeAlert("Content Field is Empty")
                   self.present(alert, animated: true, completion: nil)
                   return
               }
             
             let loca = location.text ?? ""
             
            
             let viewControllers = self.navigationController?.viewControllers
             let parent = viewControllers?[1] as! PersonalViewController
             
                  let storage = Storage.storage()
                  let storageRef = storage.reference()
                  let imageName = NSUUID().uuidString
                  
                 
                      
                  let photoRef = storageRef.child("\(imageName)")
                  
                      guard let imageData = self.pic.image?.jpegData(compressionQuality: 0.1) else {
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
                     let  posts = Post(userName: name, pcontent: ccontent, pdatetime: datetime, userLocation: loca, pimageName: photo ,opened:false , commentPost: [ ] )
         
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
    
    func afterDbOperation(parent: PersonalViewController, isSuccess: Bool, isUpdating: Bool) {
        if !isSuccess {
            let mode = isUpdating ? "updating the" : "adding a"
            self.present(Team3Helper.makeAlert("Wasn't successful in \(mode) post"), animated: true)
        }
        
        parent.loadPosts()
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
