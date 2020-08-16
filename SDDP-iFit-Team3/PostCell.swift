//
//  PostCell.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var pcontentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentbtn: UIButton!
    
    @IBOutlet weak var deletebtn: UIButton!
    
    @IBOutlet weak var commmentview: UITextView!
    
    @IBOutlet weak var viewcmt: UIButton!
    
    @IBOutlet weak var commentsTableView: UITableView!
    var comments: [Comment] = []
    
    
 
    
    
    @IBOutlet weak var cmt: UILabel!
    
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var datelabel: UILabel!
    
    
    @IBOutlet weak var place: UILabel!
    
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var content: UILabel!
    
    
    @IBOutlet weak var edit: UIButton!
    
    
   
    
    
    @IBOutlet weak var profileimg: UIImageView!
    
    
    @IBOutlet weak var proImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
       
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editpressed(_ sender: Any) {
        
        
       
        
        //navigationController?.pushViewController(addVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count > 2 {
            return 2
        }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        let comment = self.comments[indexPath.row]
        
        cell.textLabel?.text = comment.userId
        cell.detailTextLabel?.text = comment.comment
        
        
        return cell
    }
}
