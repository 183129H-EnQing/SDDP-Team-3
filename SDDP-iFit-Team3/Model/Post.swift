//
//  Post.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class Comment:Codable{
    
    var userId: String
    var comment: String
    var pdatetime:String
    var profile: String
  

    init(userId: String, comment:String, pdatetime:String , profile:String)
 {
    self.userId = userId
    self.comment = comment
    self.pdatetime = pdatetime
    self.profile = profile
    
    
    }

}

  class Post : NSObject {
        var id: String?
        var userId: String
        var pcontent: String
        var pdatetime:String
        var pimageName: String
        var userLocation: String
        var opened : Bool
        var profileImg : String
        var commentPost : [Comment]

    init(userId: String, pcontent:String, pdatetime:String, userLocation:String,  pimageName:String , opened:Bool , profileImg:String, commentPost: [Comment] )
     {
    
        self.userId = userId
        self.pcontent = pcontent
        self.pdatetime = pdatetime
        self.userLocation = userLocation
        self.pimageName = pimageName
        self.opened = opened
        self.profileImg = profileImg
        self.commentPost = commentPost
        
        }
     
    
    }

   
