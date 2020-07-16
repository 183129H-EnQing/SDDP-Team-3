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
    
    

    @IBOutlet weak var tableView: UITableView!
    
   
    @IBOutlet weak var searchbar: UISearchBar!
    var  searchPost : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchbar.delegate = self
        
    
        self.navigationItem.title = "Posts"
        
       
        
        
        
       
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
        
        
        
       
            return postList.count
       
        
   
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
        //let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
       
                let cell : PostCell = tableView
                .dequeueReusableCell (withIdentifier: "PostCell", for: indexPath) as! PostCell
                let p = postList[indexPath.row]
                cell.nameLabel.text = p.userName
                cell.pcontentLabel.text = "\(p.pcontent) "
                cell.locationLabel.text = "\(p.userLocation)"
                cell.timeLabel.text = "\(p.pdatetime)"
                cell.ppimageView.sd_setImage(with: URL(string: p.pimageName))
                
            
            
                
        
             //  DispatchQueue.global(qos: .userInitiated).async {
                 // cell.ppimageView.sd_setImage(with: URL(string: p.pimageName))
                   // Bounce back to the main thread to update the UI
                //DispatchQueue.main.async {
                   // cell.ppimageView.sd_setImage(with: URL(string: p.pimageName))
                
                // }
             //  }                    //UIImage(named:p.pimageName)
                cell.commentbtn.tag = indexPath.row

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
        
        if (editingStyle == .delete){
            //postList.remove(at: indexPath.row)
           // tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            
            DataManager.Posts.deletePost(post: self.postList[indexPath.row]) { (isSuccess) in
                           if isSuccess {
                               self.loadPosts()
                           } else {
                               self.present(Team3Helper.makeAlert("Wasn't able to delete this schedule"), animated: true)
                           }
                       }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
     }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchPost = [ ]
        
        let pp = postList
        
        let stringP = pp.description
        
        
        for posts in stringP {
            
            if posts.lowercased().contains(searchText.lowercased()){
                
                //searchPost.append(posts)
            }
        }
        
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
        
            DataManager.Posts.loadPosts(userId: user.uid) { (data) in
                    if data.count > 0 {
                        print("data loaded")
                        self.postList = data
                        
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
