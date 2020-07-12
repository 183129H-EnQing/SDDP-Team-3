//
//  GenericTopNavViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/6/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class GenericTopNavViewController: UIViewController {

    let profileStoryboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    
    // Thank god : http://swiftdeveloperblog.com/code-examples/create-uibarbuttonitem-programmatically/
    var profileBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profileBarButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(GenericTopNavViewController.profileButtonPressed(_:)))
        if var leftBarItems = self.navigationItem.leftBarButtonItems {
            leftBarItems.append(self.profileBarButton!)
        } else {
            self.navigationItem.leftBarButtonItems = [self.profileBarButton!]
        }
    }
    
    @objc func profileButtonPressed(_ sender: UIBarButtonItem!) {
        print("Profile btn click")
        let controller = profileStoryboard.instantiateViewController(identifier: "ProfileViewController")
        self.navigationController?.pushViewController(controller, animated: true)
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
