//
//  PostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import FirebaseUI

class PostViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    var postList : [Post] = []
    
    var cmt = [Comment]()
    
    
    var currentUserId : String = ""
    
  // var userName : String = ""
    @IBOutlet weak var tableView: UITableView!
    
   
    @IBOutlet weak var searchbar: UISearchBar!
    var  searchPost : [Post] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchbar.delegate = self
        
    
        self.navigationItem.title = "Posts"
        
       //getCurrentUser()
        
        
        
       
        //postList.append(Post(
        //userName: "Paul",
        //pcontent: "Keep Fit",
        //pdatetime: "5.34PM",
        //userLocation:"YISHUN",
        //pimageName:  "thumbnail_images",
        //commentPost: [ ]
        //))
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        loadPosts()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchPost.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
       
        let cell : PostCell = tableView
        .dequeueReusableCell (withIdentifier: "PostCell", for: indexPath) as! PostCell
        let p = searchPost[indexPath.row]

        DataManager.getUserData(userId: p.userId) { (data) in
            if let user = data {
                let userName = user.username!
                print("fddddd", userName)
                cell.nameLabel.text = userName
                print("data",data)
            }
        }
        cell.comments = p.commentPost
        cell.commentsTableView.reloadData()
        
        cell.pcontentLabel.text = "\(p.pcontent) "
        cell.locationLabel.text = "\(p.userLocation)"
        cell.timeLabel.text = "\(p.pdatetime)"
        cell.photo.sd_setImage(with: URL(string: p.pimageName))
        
        cell.profileimg.layer.cornerRadius = cell.profileimg.frame.size.width / 2
        cell.profileimg.clipsToBounds = true
        cell.profileimg.sd_setImage(with: URL(string: p.profileImg))
        cell.commentbtn.tag = indexPath.row
        cell.viewcmt.tag = indexPath.row

        return cell
        
    }
    
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if postList[indexPath.section].opened == true {
           // postList[indexPath.section].opened = false
           // let section = IndexSet.init(integer: indexPath.section)
           // tableView.reloadSections(section, with: .none)
            
       // }
       // else{
            // postList[indexPath.section].opened = true
          //  let section = IndexSet.init(integer: indexPath.section)
           // tableView.reloadSections(section, with: .none)
        //}
    //}
    //delete
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         
        let p = searchPost[indexPath.row]
    
                   
       
        if (editingStyle == .delete){
            //postList.remove(at: indexPath.row)
           // tableView.deleteRows(at: [indexPath], with: .automatic)
            print("plsss", p.userId,UserAuthentication.getLoggedInUser()?.uid)
            
            if p.userId == UserAuthentication.getLoggedInUser()!.uid{
            
                DataManager.Posts.deletePost(post: self.searchPost[indexPath.row]) { (isSuccess) in
                           if isSuccess {
                               self.loadPosts()
                           } else {
                               self.present(Team3Helper.makeAlert("Wasn't able to delete this post"), animated: true)
                           }
                       }
            }
             else{
                 let alert = Team3Helper.makeAlert("You cant delete others post")
                                      self.present(alert, animated: true, completion: nil)
                                      return
            }
        }
        
    }
    
//     func getCurrentUser() {
//
//             //  self.noSchedulesLabel.isHidden = false
//
//               if let user = UserAuthentication.getLoggedInUser() {
//                   print("User is logged in")
//
//                   DataManager.getUserData(userId: user.uid) { (data) in
//
//                    self.currentUserId = UserAuthentication.
//                                print("fdfdfdfd", self.currentUserId)
//                               print("data",data)
//
//                           }
//                       }
//               }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let pIndexPath = self.tableView.indexPathForSelectedRow
       
            if(segue.identifier == "ShowPostDetails")
            
     { let detailViewController = segue.destination as! EditPostViewController
        let myIndexPath = self.tableView.indexPathForSelectedRow
           if(myIndexPath != nil) {
   
           let posts = postList[myIndexPath!.row]
               detailViewController.postItem = posts
                
        }

            }
           
        
        
        
        if(segue.identifier == "ShowPostComments")
         {
            let detailViewController = segue.destination as! CommentPostViewController
            
            let posts = postList[(sender as! UIButton).tag]
                    detailViewController.postItem = posts
                     
             

                 }
        
//         if(segue.identifier == "ViewComments")
//                {
//                   let detailViewController = segue.destination as! ViewCommentViewController
//
//                   let posts = postList[(sender as! UIButton).tag]
//                           detailViewController.comments = posts
//
//
//
//                        }
//
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            searchPost = postList
            tableView.reloadData()
            return
        }
        
        searchPost = postList.filter({ (Post) -> Bool in
          guard  let text = searchBar.text else {return false}
            return Post.pcontent.lowercased().contains(text.lowercased())
            
        })
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    
    }
    
    
    
    
      //@IBAction func unwindToPostList(sender: UIStoryboardSegue) {
          // if let sourceViewController = sender.source as? AddPostViewController, let posts = sourceViewController.postItem {
                
            //if let user = UserAuthentication.getLoggedInUser(){
                                
                       //  let newIndexPath = IndexPath(row: postList.count, section: 0)
                         
                       //  postList.append(posts)
                       //  tableView.insertRows(at: [newIndexPath], with: .automatic)
                        // let viewControllers = self.navigationController?.viewControllers
                        // let parent = viewControllers?[1] as! PostViewController
                
                        // DataManager.Posts.insertPost(userId:user.uid,posts) { (isSuccess) in
                                //self.afterDbOperation(parent: parent, isSuccess: isSuccess, isUpdating: false)
              //  }
                        
            //    }//
                              
           //  }
    //  }
    
    
    
    
     @IBAction func unwindToPostListEdit(sender: UIStoryboardSegue) {
              if let sourceViewController = sender.source as? EditPostViewController, let posts = sourceViewController.postItem {
                   
               
                     if let selectedIndexPath = tableView.indexPathForSelectedRow {
                               // Update an existing meal.
                                postList[selectedIndexPath.row] = posts
                               tableView.reloadRows(at: [selectedIndexPath], with: .none)
                           }
                    
                }
         }
    
    
    func loadPosts() {
        self.postList = []
        self.tableView.isHidden = true
        
        if let user = UserAuthentication.getLoggedInUser() {
            print("User is logged in")
        
            DataManager.Posts.loadAllPosts(userId: user.uid) { (data) in
                    if data.count > 0 {
                        print("posts data loaded")
                        self.postList = data
                        self.searchPost = data
                        
                        DispatchQueue.main.async {
                            print("async tableview label")
                            self.tableView.reloadData()
                            self.tableView.isHidden = false
                            
                         
                        }
                    }
                }
        }
    }    //*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
         //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
   // }
   // */

}
