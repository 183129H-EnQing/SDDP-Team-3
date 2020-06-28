//
//  EditPostViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/27/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController {
    
    @IBOutlet weak var textcontent: UITextField!
    
    @IBOutlet weak var postimage: UIImageView!
    
    var postItem : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    textcontent.text = postItem?.pcontent
    postimage.image = UIImage(named: (postItem?.pimageName)!)
      
    self.navigationItem.title = "Edit Post"
        
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
