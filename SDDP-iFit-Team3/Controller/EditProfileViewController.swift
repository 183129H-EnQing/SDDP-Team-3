//
//  EditProfileViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/12/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //@IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var avatarImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // circle image ref: https://www.ioscreator.com/tutorials/circular-image-view-ios-tutorial
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.backgroundColor = UIColor.black.cgColor
        avatarImgView.layer.cornerRadius = avatarImgView.bounds.height/2
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage: UIImage = info[.editedImage] as! UIImage
        
        let cropRect = info[.cropRect] as! CGRect
        avatarImgView.image = chosenImage.sd_resizedImage(with: CGSize(width: cropRect.height, height: cropRect.height), scaleMode: .aspectFit)
        
        print(chosenImage.size)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        picker.dismiss(animated: true)
    }
    
    @IBAction func chgAvatarBtnPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true)
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        if let user = UserAuthentication.getLoggedInUser() {
            StorageManager.uploadUserProfile(userId: user.uid, image: avatarImgView.image!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
