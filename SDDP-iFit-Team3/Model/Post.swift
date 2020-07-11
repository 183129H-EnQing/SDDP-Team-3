//
//  Post.swift
//  SDDP-iFit-Team3
//
//  Created by 180116H  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class Comment {
    
    var userName: String
    var comment: String
    var pdatetime:String
  

init(userName: String, comment:String, pdatetime:String)
 {
    self.userName = userName
    self.comment = comment
    self.pdatetime = pdatetime
    
    }

}

  class Post : NSObject {
        var id: String?
        var userName: String
        var pcontent: String
        var pdatetime:String
        var pimageName: String
        var userLocation: String
        var commentPost : [Comment]

    init(userName: String, pcontent:String, pdatetime:String, userLocation:String,  pimageName:String , commentPost: [Comment] )
     {
    
        self.userName = userName
        self.pcontent = pcontent
        self.pdatetime = pdatetime
        self.userLocation = userLocation
        self.pimageName = pimageName
        self.commentPost = commentPost
        
        }
     
    
    }

   
