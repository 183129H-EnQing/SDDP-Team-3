//
//  Exercise.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 6/21/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class Exercise: NSObject {

    var exName: String  //id in Firebase
    var exDesc : String
    var exImage: String
    
    init(exName: String, exDesc: String, exImage: String){
        self.exName = exName
        self.exDesc = exDesc
        self.exImage = exImage
    }
}
