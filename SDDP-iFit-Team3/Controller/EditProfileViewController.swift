//
//  EditProfileViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/12/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //@IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var previousAvatar: UIImage?
    var previousUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Team3Helper.makeImgViewRound(avatarImgView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let previousAvatar = self.previousAvatar {
            avatarImgView.image = previousAvatar
        }
        if let previousUsername = self.previousUsername {
            usernameTextField.text = previousUsername
        }
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
        Team3Helper.colorTextFieldBorder(textField: usernameTextField, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: passwordTextField, isRed: false)
        Team3Helper.colorTextFieldBorder(textField: newPasswordTextField, isRed: false)
        
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        let newPassword = self.newPasswordTextField.text
        
        if username == "" {
            Team3Helper.colorTextFieldBorder(textField: usernameTextField, isRed: true)
            self.present(Team3Helper.makeAlert("'Username' cannot be empty!"), animated: true)
            return
        }
        
        if newPassword != "" {
            
            if password == "" {
                Team3Helper.colorTextFieldBorder(textField: passwordTextField, isRed: true)
                self.present(Team3Helper.makeAlert("'Password' cannot be empty if you want to change password!"), animated: true)
                return
            }
            
            if newPassword!.elementsEqual(password!) {
                Team3Helper.colorTextFieldBorder(textField: newPasswordTextField, isRed: true)
                self.present(Team3Helper.makeAlert("'New Password' cannot be the same as 'Password'!"), animated: true)
                return
            }
        }
        
        if let user = UserAuthentication.getLoggedInUser() {
            if newPassword != "" {
                updateProfile(user: user, username: username!, shouldReroute: false) {
                    user.reauthenticate(with: EmailAuthProvider.credential(withEmail: user.email!, password: password!), completion: { (authResult, err) in
                        guard let user2 = authResult?.user, err == nil else {
                            let errCode = (err! as NSError).code
                            var errMsg = err?.localizedDescription
                            
                            if errCode == AuthErrorCode.wrongPassword.rawValue {
                                errMsg = "Wrong password used"
                            }
                            print(err)
                            
                            self.present(Team3Helper.makeAlert("Re-Authentication failed: \(errMsg!)"), animated: true)
                            
                            return
                        }
                        
                        user2.updatePassword(to: newPassword!) { (err) in
                            if let err = err {
                                print("Error updating password: \(err)")
                                return
                            } else {
                                // change to logout
                                print("Success updating password")
                                UserAuthentication.logoutUser("Change password success! Please re-login")
                            }
                        }
                    })
                }
            } else {
                updateProfile(user: user, username: username!, shouldReroute: true, onComplete: nil)
            }
        }
    }
    
    func updateProfile(user: FirebaseAuth.User, username: String, shouldReroute: Bool, onComplete: (() -> Void)?) {
        StorageManager.uploadUserProfile(userId: user.uid, image: avatarImgView.image!) { url in
            if let url = url {
                print("updateProfile")
                // to prevent pointless database updates if username did not change
                let isUsernameSame: Bool = self.previousUsername != nil && self.previousUsername!.elementsEqual(username)
                
                var userData: [String:Any] = ["avatarURL": url.absoluteString]
                
                if !isUsernameSame {
                    UserAuthentication.user!.username = username
                    userData["username"] = username
                }
                UserAuthentication.user!.avatarURL = url
                
                DispatchQueue.global(qos: .background).async {
                    DataManager.updateUser(userId: user.uid, userData: userData)
                }
                
                if shouldReroute {
                    let viewControllers = self.navigationController?.viewControllers
                    let controller = viewControllers?[1] as! ProfileViewController
                    controller.avatarImgView.image = self.avatarImgView.image
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            onComplete?()
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
