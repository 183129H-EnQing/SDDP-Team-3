//
//  AchievementViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 29/6/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import Charts
class AchievementViewController: UIViewController {
    var days: [String]!
       
    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
           super.viewDidLoad()
           
           days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
           let tasks = [1.0, 1.0, 1.5, 2.0, 3.0, 5.0, 0.0]
           
        setChart(dataPoints:days, values: tasks)
       }
       
       func setChart(dataPoints: [String], values: [Double]) {
           
           
           var dataEntries: [BarChartDataEntry] = []
           var counter = 0.0
           
           for i in 0..<dataPoints.count {
               counter += 1.0
               let dataEntry = BarChartDataEntry(x: values[i], y: counter)
               dataEntries.append(dataEntry)
           }
           
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Time")
           let chartData = BarChartData()
           chartData.addDataSet(chartDataSet)
           barChartView.data = chartData
           
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
