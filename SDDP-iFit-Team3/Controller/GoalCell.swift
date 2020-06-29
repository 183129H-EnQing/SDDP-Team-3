//
//  GoalCell.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 29/6/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var dateRange: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
