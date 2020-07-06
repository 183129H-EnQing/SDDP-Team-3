//
//  CommentPostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 6/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class CommentPostViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    
    @IBOutlet weak var imageview: UIImageView!
    
    
    @IBOutlet weak var textbox: UITextField!
    
    
    @IBOutlet weak var comment: UILabel!
    
    
    var postItem : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    comment.text = postItem?.pcontent
    //imageview.image = UIImage(named: (postItem?.pimageName)!)
    username.text = postItem?.userName
    time.text = postItem?.pdatetime
    location.text = postItem?.userLocation
        
      
    self.navigationItem.title = "Comment"
        
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
