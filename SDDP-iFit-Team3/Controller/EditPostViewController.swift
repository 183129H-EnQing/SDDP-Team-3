//
//  EditPostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/27/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import os.log

class EditPostViewController: UIViewController {
    
    @IBOutlet weak var textcontent: UITextField!
    
    @IBOutlet weak var postimage: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
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
        
        
           
           //let photo = imageview.image
           
        
           postItem = Post(userName: "Dinesh", pcontent: content, pdatetime: "5.34", userLocation: "yishun", pimageName: "")
           
       }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
