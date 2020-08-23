//
//  CommentPostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 6/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class CommentPostViewController: UIViewController,UITextViewDelegate{
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    
    @IBOutlet weak var imageview: UIImageView!
    
    
    @IBOutlet weak var textbox: UITextField!
    
    
    @IBOutlet weak var comment: UILabel!
    
   
    @IBOutlet weak var savebtn: UIButton!
    
    var postItem : Post?
    
    var cmtItem : Comment?
    
     var uurl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         textbox.placeholder = "comment here"
         getProfilePic()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    comment.text = postItem?.pcontent
    imageview.image = UIImage(named: (postItem?.pimageName)!)
        
        DataManager.getUserData(userId: postItem!.userId) { (data) in
                       if let user = data {
                           let userName = user.username!
                            print("fddddd", userName)
                        self.username.text = userName
                           print("data",data)
                           }
                       }
    location.text = postItem?.userLocation
    imageview.sd_setImage(with: URL(string : postItem!.pimageName))
      
    self.navigationItem.title = "Comments"
        
    }
    
     func getProfilePic(){
           if let user = UserAuthentication.getLoggedInUser() {
              
           
               DataManager.getUserData(userId: user.uid) { (UserAunthentication) in
                       if let user = UserAuthentication.user{
                           
                          // let urrrl : String = ""
                         
                          let url =  user.avatarURL
                           let uu = url?.absoluteString
                           if url != nil  {
                            self.uurl = uu!
                                }
                                                  
                           
                           print("aaaaaaaa", self.uurl)
                                       
                          
                           }
                       }
                   }
          
           
       }
    
    
    @IBAction func savebtnpressed(_ sender: Any) {
         if let user = UserAuthentication.user {
                   
                  // let content = comment.text!
                         let date = Date()
                         let formatter = DateFormatter()
                        formatter.dateFormat = "MMM d, h:mm a"
                         let datetime = formatter.string(from: date)
            //let name = user.username
              // let loca = location.text ?? ""
            let com = textbox.text ?? ""
            
            if com == "" {
                let alert = Team3Helper.makeAlert("Comment cannot be empty")
                self.present(alert, animated: true, completion: nil)
                return
            }
               
                   let viewControllers = self.navigationController?.viewControllers
                
                   let parent = viewControllers?[1] as! PostViewController
            let purl = self.uurl
            
            postItem?.commentPost.append(Comment(userId: user.username!, comment: com, pdatetime: datetime , profile: purl  ))
               
            DataManager.Posts.insertComment(userId:user.userId, postId: postItem!.id!, postItem!.commentPost) { (isSuccess) in
               self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
            }

//                     if self.postItem != nil {
//                                           // Update
//
//
//                                           posts.id = self.postItem!.id!
//                                           DataManager.Posts.updatePost(post: posts) { (isSuccess) in
//                                               self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: true)
//                                           }
//                                       } else {
//                                           // Add
//                                           DataManager.Posts.insertPost(userId:user.uid,posts) { (isSuccess) in
//                                                              self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
//
//                                                  }
//                                       }
                                           
                //
                                      
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
