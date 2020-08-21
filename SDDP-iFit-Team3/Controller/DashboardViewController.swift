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
    
    @IBOutlet weak var CircularProgress: CircularProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
//              cp.trackColor = UIColor.white
//              cp.progressColor = UIColor(red: 252.0/255.0, green: 141.0/255.0, blue: 165.0/255.0, alpha: 1.0)
//
//              cp.tag = 101
//              self.view.addSubview(cp)
//              cp.center = self.view.center
//
//              self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)

              CircularProgress.trackColor = UIColor.white
              CircularProgress.progressColor = UIColor.purple
              CircularProgress.setProgressWithAnimation(duration: 0.0, value: 0.3)
        authorizeAndGetHealthKit()
        // Do any additional setup after loading the view.
        //Team3Helper.makeImgViewRound(profileBarButton!)
    }
    
    @objc func animateProgress() {
          let cP = self.view.viewWithTag(101) as! CircularProgressView
          cP.setProgressWithAnimation(duration: 0, value: 0.7)
          
    }
        func authorizeAndGetHealthKit() {

               HealthKitManager.authorizeHealthKit(){ (authorizeStatus) in
                   print("hello",authorizeStatus!)
                   let authoriseStatusValue = authorizeStatus!
                   if (!authoriseStatusValue){
                       self.presentHealthDataNotAvailableError()
                   }else{
              
                         HealthKitManager.getHealthKitData(){print("testing1")}
         
                     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                         // Put your code which should be executed with a delay here
                       DataManager.HealthKitActivities.loadHealthKitActivity(userId: UserAuthentication.user!.userId){
                                                  (data) in
                                              if data.count > 0 {
                                               print("pui pui pui pui")
                                                  //let calendar = Calendar.current
                                           //    self.healthKitActivityList = data
                                           //    self.displayData()

                                               }

                                           }
                       }
                      
                   }
               }

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

    
   private func presentHealthDataNotAvailableError() {
          let title = "Health Data Unavailable"
          let message = "Aw, shucks! We are unable to access health data on this device. Make sure you are using device with HealthKit capabilities."
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let action = UIAlertAction(title: "Dismiss", style: .default)
          
          alertController.addAction(action)
          
          present(alertController, animated: true)
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
