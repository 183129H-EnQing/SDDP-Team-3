//
//  DashboardViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import SwiftUI

class DashboardViewController: UIViewController {

    var actvityList  = ["Challenges","Exercise"]

    @IBOutlet weak var profileBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Team3Helper.makeImgViewRound(profileBarButton!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let user = UserAuthentication.user, let url = user.avatarURL {
                if let data = try? Data(contentsOf: url) {
                    // to make the image color default color: https://stackoverflow.com/a/22483234
                    let image = UIImage(data: data)?.sd_resizedImage(with: CGSize(width: 30, height: 30), scaleMode: .aspectFit)?.withRenderingMode(.alwaysOriginal)
                    
                    DispatchQueue.main.async {
                        self.profileBarButton.image = image
                    }
                }
            }
        }
    }

    
   
//    @IBSegueAction func hello(_ coder: NSCoder) -> UIViewController? {
//   
//        return UIHostingController(coder: coder, rootView: testingView())
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct DashboardViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
