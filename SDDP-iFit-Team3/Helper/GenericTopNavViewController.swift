//
//  GenericTopNavViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 7/6/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class GenericTopNavViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let profileBarButton = UIBarButtonItem(title: "Profile", style: .plain, target: nil, action: nil)
        if var leftBarItems = self.navigationItem.leftBarButtonItems {
            leftBarItems.append(profileBarButton)
        } else {
            self.navigationItem.leftBarButtonItems = [profileBarButton]
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
