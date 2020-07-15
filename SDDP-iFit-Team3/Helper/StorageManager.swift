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
    
    static func uploadUserProfile(userId: String, image: UIImage, onComplete: ((URL?) -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            let ref = storage.reference().child("avatars/\(userId)")
            
            let metadata = StorageMetadata()
            let data = image.jpegData(compressionQuality: 0.5)!
            metadata.contentType = "image/jpg"
            
            ref.putData(data, metadata: metadata) { (metadata, err) in
                if let err = err {
                    print("got error! cry \(err)")
                }
                else if let _ = metadata {
                    ref.downloadURL { (url, err) in
                        if let err = err {
                            print("error getting url: \(err)")
                        } else if let url = url {
                            onComplete?(url)
                        } else {
                            onComplete?(nil)
                        }
                    }
                }
            }
        }
    }
    
    static func getUserProfile(userId: String, onComplete: ((URL?) -> Void)?) {
        let pathRef = storage.reference(withPath: "avatars/\(userId)")
        //let pathRef = storage.reference(withPath: "04450645-C33A-4E9C-8208-BE4C0C9A39A2")
        
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
