//
//  ProfileViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/11/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = UserAuthentication.getLoggedInUser() {
            DataManager.getUsername(userId: user.uid, onComplete: { (username) in
                self.usernameLabel.isHidden = false
                self.usernameLabel.text = username
            })
        
            StorageManager.getUserProfile(userId: user.uid) { (url) in
                if let url = url {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.avatarImgView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserAuthentication.logoutUser()
        UIApplication.shared.windows[0].rootViewController = SceneDelegate.mainStoryboard.instantiateViewController(identifier: "WelcomeNavController")
        UIApplication.shared.windows[0].rootViewController!.present(Team3Helper.makeAlert("Success Registration! Go login!"), animated: true)
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
