//
//  CommentsCell.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 8/15/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var vusername: UILabel!
    @IBOutlet weak var vcomment: UILabel!
    @IBOutlet weak var vdate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
