//
//  Post.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit


    class Post : NSObject {
        var postid: String?
        var userName: String
        var pcontent: String
        var pdatetime:String
        var pimageName: String
        var userLocation: String

    init(userName: String, pcontent:String, pdatetime:String, userLocation:String,  pimageName:String)
     {
        self.userName = userName
        self.pcontent = pcontent
        self.pdatetime = pdatetime
        self.userLocation = userLocation
        self.pimageName = pimageName
        
        }

    }
