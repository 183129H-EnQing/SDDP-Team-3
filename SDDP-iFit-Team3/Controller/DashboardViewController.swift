//
//  DashboardViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import SwiftUI

class DashboardViewController: UIViewController{

    var actvityList  = ["Challenges","Exercise"]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return actvityList.count
//
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
//
//                let cell : DashBoardViewCell = tableView
//                .dequeueReusableCell (withIdentifier: "DashBoardCell", for: indexPath) as! DashBoardViewCell
//
//   //     cell.activityName.text = actvityList[indexPath.row]
//        print("heloo world")
//
//                return cell
//        }
    
   
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
