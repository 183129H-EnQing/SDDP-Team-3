	//
//  CardDesign.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 6/26/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class CardDesign: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
            layer.cornerRadius = 20.0
             layer.shadowColor = UIColor.gray.cgColor
             layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
             layer.shadowRadius = 12.0
             layer.shadowOpacity = 0.7
    }
     
}
