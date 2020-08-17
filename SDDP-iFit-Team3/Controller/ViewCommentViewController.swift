//
//  ViewCommentViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 7/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class ViewCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var postList : [Post] = []
    var comments : [Comment] = []
    var postItem : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.navigationItem.title = "Comments"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        
       
           //loadComments()
        
        comments = postItem!.commentPost
        
    }
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      
      
     
          return comments.count
     
      
 
      
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
      //let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
     
              let cell : CommentsCell = tableView
              .dequeueReusableCell (withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
              let p = comments[indexPath.row]
              cell.vusername?.text = p.userId
              cell.vcomment?.text = "\(p.comment) "
              cell.vdate.text = "\(p.pdatetime)"
              cell.pimg.sd_setImage(with: URL(string: p.profile))
    
                                   return cell
      
      }
    
     func loadComments() {
           self.comments = []
           self.tableView.isHidden = true
        
           
           if let user = UserAuthentication.getLoggedInUser() {
               print("User is logged in")
            
            let post = postItem?.userId
           
            DataManager.Posts.loadAllComments(userId: post!) { (data) in
                       if data.count > 0 {
                           print("posts data loaded")
                           self.comments = data
                           //self.searchPost = data
                           
                           DispatchQueue.main.async {
                               print("async tableview label")
                               self.tableView.reloadData()
                               self.tableView.isHidden = false
                               
                            
                           }
                       }
                   }
           }
       }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
