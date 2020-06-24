//
//  TrainingPlanCell.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 6/23/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class TrainingPlanCell: UITableViewCell {

    @IBOutlet weak var trainingPlanImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
