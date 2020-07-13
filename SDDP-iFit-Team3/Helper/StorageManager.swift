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
    
    static func uploadUserProfile(userId: String, image: UIImage) {
        DispatchQueue.global(qos: .background).async {
            let ref = storage.reference().child("avatars/\(userId)")
            
            let metadata = StorageMetadata()
            let data: Data?
            if let pngData = image.pngData() {
                data = pngData
                metadata.contentType = "image/png"
            } else if let jpgData = image.jpegData(compressionQuality: 0.5) {
                data = jpgData
                metadata.contentType = "image/jpg"
            } else {
                print("failed to get data")
                return
            }
            
            ref.putData(data!, metadata: metadata) { (metadata, err) in
                if let err = err {
                    print("got error! cry \(err)")
                }
                else if let _ = metadata {
                    print("idk what's going on")
                } else {
                    print("did it fail?")
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
                print("url: \(downloadUrl?.absoluteURL)")
                url = downloadUrl
            }
            
            onComplete?(url)
        }
    }
}
