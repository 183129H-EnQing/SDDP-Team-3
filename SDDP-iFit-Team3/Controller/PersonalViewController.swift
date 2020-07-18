//
//  PersonalViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 7/17/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import FirebaseUI

class PersonalViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var postList : [Post] = []
    
    @IBOutlet weak var taleview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.title = "My Posts"
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        
       
           loadPosts()

        
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           
           
          
               return postList.count
          
           
      
           
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
           //let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
          
                   let cell : PostCell = tableView
                   .dequeueReusableCell (withIdentifier: "PostCell", for: indexPath) as! PostCell
                   let p = postList[indexPath.row]
                   cell.username.text = p.userName
                   cell.content.text = "\(p.pcontent) "
                   cell.place.text = "\(p.userLocation)"
                   cell.datelabel.text = "\(p.pdatetime)"
                  
           //DispatchQueue.global(qos: .userInitiated).async{
           //if let data = try? Data(contentsOf: NSURL(string: p.pimageName)! as URL){
                //DispatchQueue.main.async {
                   cell.photo.sd_setImage(with: URL(string: p.pimageName))
                   //cell.ppimageView.image = UIImage(data: data)
                   
                 /// }
              // }
           //}
           
                  
                   
               
               
                   
           
                //  DispatchQueue.global(qos: .userInitiated).async {
                    // cell.ppimageView.sd_setImage(with: URL(string: p.pimageName))
                      // Bounce back to the main thread to update the UI
                   //DispatchQueue.main.async {
                      // cell.ppimageView.sd_setImage(with: URL(string: p.pimageName))
                   
                   // }
                //  }                    //UIImage(named:p.pimageName)
                   

                   return cell
           
           }
    
     func loadPosts() {
           self.postList = []
           
          
           
           self.taleview.isHidden = true
        
           
           if let user = UserAuthentication.getLoggedInUser() {
               print("User is logged in")
           
               DataManager.Posts.loadPosts(userId: user.uid) { (data) in
                       if data.count > 0 {
                           print("data loaded")
                           self.postList = data
                           //self.searchPost = self.postList
                           
                           DispatchQueue.main.async {
                               print("async tableview label")
                               self.taleview.reloadData()
                               self.taleview.isHidden = false
                               
                            
                           }
                       }
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