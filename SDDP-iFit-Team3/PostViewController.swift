//
//  PostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class PostViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var postList : [Post] = []

    @IBOutlet weak var tableView: UITableView!
    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        
        self.navigationItem.title = "Posts"
        self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add,
                        target: self,
                        action: #selector(addButtonClicked))
        
       
        postList.append(Post(
        userName: "Paul",
        pcontent: "Keep Fit",
        pdatetime: "5.34PM",
        userLocation:"YISHUN",
        pimageName:  "thumbnail_images"))
        // Do any additional setup after loading the view.
    }
    
    
   
    
    
    @objc func addButtonClicked()
    {
              let s = UIStoryboard(name: "Community", bundle: nil)
              let v = s.instantiateViewController(withIdentifier:"AddPostViewController") as! AddPostViewController
              self.present(v, animated: true, completion: nil)
    

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
                cell.ppimageView.image = UIImage(named:p.pimageName)

                return cell
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
     }
    
      @IBAction func unwindToPostList(sender: UIStoryboardSegue) {
           if let sourceViewController = sender.source as? AddPostViewController, let posts = sourceViewController.postItem {
                 
                 // Add a new meal.
                 let newIndexPath = IndexPath(row: postList.count, section: 0)
                 
                 postList.append(posts)
                 tableView.insertRows(at: [newIndexPath], with: .automatic)
             }
      }
    
    //*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
         //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
   // }
   // */

}
