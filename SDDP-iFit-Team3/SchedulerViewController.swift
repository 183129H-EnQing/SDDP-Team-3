//
//  SchedulerViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 183129H  on 6/22/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var testData: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Scheduler"
        self.testData = [
            "Push Up",
            "Jumping Jacks",
            "Skipping Rope"
        ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)
        cell.textLabel?.text = testData[indexPath.row]
        
        return cell;
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
