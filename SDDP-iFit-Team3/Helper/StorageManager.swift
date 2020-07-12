//
//  StorageManager.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/11/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let storage = Storage.storage()
    
    static func uploadUserProfile(userId: String) {
        
    }
    
    static func getUserProfile(userId: String, onComplete: ((URL?) -> Void)?) {
        //let pathRef = storage.reference(withPath: "avatars/\(userId)")
        let pathRef = storage.reference(withPath: "04450645-C33A-4E9C-8208-BE4C0C9A39A2")
        
        pathRef.downloadURL { (downloadUrl, err) in
            var url: URL?
            
            if let err = err {
                print("failed to download profile: \(err)")
            } else {
                url = downloadUrl
            }
            
            onComplete?(url)
        }
    }
}
