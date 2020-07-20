//
//  PostCell.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell{

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
   
    @IBOutlet weak var ppimageView: UIImageView!
    
    @IBOutlet weak var pcontentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentbtn: UIButton!
    
    @IBOutlet weak var deletebtn: UIButton!
    
    @IBOutlet weak var commmentview: UITextView!
    
    @IBOutlet weak var viewcmt: UIButton!
    
    
    @IBOutlet weak var cmt: UILabel!
    
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var datelabel: UILabel!
    
    
    @IBOutlet weak var place: UILabel!
    
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var content: UILabel!
    
    
    @IBOutlet weak var edit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editpressed(_ sender: Any) {
        
        
       
        
        //navigationController?.pushViewController(addVC, animated: true)
    }
    

}
