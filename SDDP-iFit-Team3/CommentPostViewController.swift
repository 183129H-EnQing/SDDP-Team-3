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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         textbox.placeholder = "comment here"     // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    comment.text = postItem?.pcontent
    imageview.image = UIImage(named: (postItem?.pimageName)!)
    username.text = postItem?.userName
    
    imageview.sd_setImage(with: URL(string : postItem!.pimageName))
      
    self.navigationItem.title = "Comment"
        
    }
    
    
    
    @IBAction func savebtnpressed(_ sender: Any) {
         if let user = UserAuthentication.getLoggedInUser(){
                   
                   let content = textbox.text ?? ""
                         let date = Date()
                         let formatter = DateFormatter()
                        formatter.dateFormat = "MMM d, h:mm a"
                         let datetime = formatter.string(from: date)
            let name = username.text ?? ""
               let loca = location.text ?? ""
               
                   let viewControllers = self.navigationController?.viewControllers
                   let parent = viewControllers?[1] as! PostViewController
            
            let cmt = Comment(userName: name, comment: content, pdatetime: datetime )
               
            let  posts = Post(userName: name, pcontent: content, pdatetime: datetime, userLocation: loca, pimageName: "", opened: false ,  commentPost: [ cmt] )
               
                DataManager.Posts.insertComment(userId:user.uid,cmt) { (isSuccess) in
                                                               self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
                                            
                                           
                //
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
