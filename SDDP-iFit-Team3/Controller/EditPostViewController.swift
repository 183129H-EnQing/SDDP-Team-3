//
//  EditPostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/27/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import os.log

class EditPostViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var textcontent: UITextField!
    
    @IBOutlet weak var postimage: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var takePicture: UIButton!
    
    
    @IBOutlet weak var seleectPicture: UIButton!
    
    
    var postItem : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          //self.navigationItem.rightBarButtonItem =
             // UIBarButtonItem(barButtonSystemItem: .save,
                              //target: self,
                              //action: #selector(saveButtonclicked))
              
        // Do any additional setup after loading the view.
         if let postss = postItem  {
               textcontent.text = postss.pcontent
               
               
               
           }
    }
    // @objc func saveButtonclicked()
       //{
                

      // }
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    textcontent.text = postItem?.pcontent
    postimage.image = UIImage(named: (postItem?.pimageName)!)
      
    self.navigationItem.title = "Edit Post"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
              super.prepare(for: segue, sender: sender)
              
            
              guard let button = sender as? UIButton, button === saveButton else {
                  os_log("The add button was not pressed, cancelling", log: OSLog.default, type: .debug)
                  return
              }
           
           
           let content = textcontent.text ?? ""
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            let datetime = formatter.string(from: date)
        
        
        
           
           //let photo = String(postimage.image)
        
            //let pic = UIImage(named: photo)
           
        
           postItem = Post(userName: "Dinesh", pcontent: content, pdatetime: datetime, userLocation: "yishun", pimageName: "img" , commentPost: [ ] )
           
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
