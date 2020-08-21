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
    var todaySquat :Int = 0
    var todaySteps :Double = 0
    var todayCaloriesBurnt : Double = 0
    var todayRunningWalkingDistance : Double = 0
    var goalFinishedList : [String] = []
    var totalGoalCount : Int = 0
    var functionCalling : Int = 0 // preventviewdidload call the function twice
    var percent = ""
    var completedGoalCount : Int = 0
    @IBOutlet weak var goalCompletedLabel: UILabel!
    @IBOutlet weak var squatDataLabel: UILabel!
    @IBOutlet weak var runningDataLabel: UILabel!
    
    @IBOutlet weak var stepsDataLabel: UILabel!
    @IBOutlet weak var energyBurnDataLabel: UILabel!
    
     let queue = DispatchQueue(label: "Serial queue")
     let group = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CircularProgress.trackColor = UIColor.lightGray
        self.CircularProgress.progressColor = UIColor.purple
        authorizeAndGetHealthKit()
        // Do any additional setup after loading the view.
        //Team3Helper.makeImgViewRound(profileBarButton!)
    }

        func authorizeAndGetHealthKit() {

               HealthKitManager.authorizeHealthKit(){ (authorizeStatus) in
                   //print("hello",authorizeStatus!)
                   let authoriseStatusValue = authorizeStatus!
                   if (!authoriseStatusValue){
                       self.presentHealthDataNotAvailableError()
                   }else{
              
                         HealthKitManager.getHealthKitData(){print("testing1")}
         
                     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                         // Put your code which should be executed with a delay here
                        self.group.enter()
                        self.queue.async {
                           DataManager.HealthKitActivities.loadHealthKitActivity(userId: UserAuthentication.user!.userId){
                                      (data) in
                                  if data.count > 0 {
                                   
                                    self.todaySquat = 0
                                    self.todaySteps = 0
                                    self.todayCaloriesBurnt = 0
                                    self.todayRunningWalkingDistance = 0
                                    DispatchQueue.global(qos: .utility).async {
                                        
                                                 for activityData in data{
                                                       self.todaySquat += activityData.todaySquat
                                                       self.todaySteps += activityData.todayStep
                                                       self.todayCaloriesBurnt += activityData.todayCaloriesBurnt
                                                       self.todayRunningWalkingDistance += activityData.todayRunningWalkingDistance
                                           
                                              }
                                    
                                            self.loadGoalData()
                                         DispatchQueue.main.async {
                                          print("testing squat\(self.todaySquat)")
                                         
                                              self.energyBurnDataLabel.text = "\(self.todayCaloriesBurnt)"
                                              self.stepsDataLabel.text = "\(self.todaySteps)"
                                              self.runningDataLabel.text = "\(self.todayRunningWalkingDistance)km"
                                              self.squatDataLabel.text = "\(self.todaySquat)"
                                             // print("hello111111")
                                              // self.group.leave()
                                      
                                         }
                                    }
                                   }
                               }
                            self.group.leave()
                             }
                        
                        
                        self.group.enter()
                        self.queue.async {
                            self.loadGoalData()
                            self.group.leave()
                        }
                        
                       }
                      
                   }
               }
            
            self.group.notify(queue: queue) {
                       print("All tasks done")
                       
                   }
           }
    func loadGoalData(){
                                                                    
                        if let user = UserAuthentication.getLoggedInUser() {
                                   //print("User is logged in")
                               
                                   DataManager.Goals.loadGoals(userId: user.uid) { (data) in
                                        if (!self.goalFinishedList.isEmpty) {
                                                self.goalFinishedList.removeAll()
                                            }
                                           if data.count > 0 {
                                            self.totalGoalCount = data.count
                                              for goal in data{
                                                print(goal.status)
                                        
                                                  if (goal.status == "Finish Goal"){
                                                      // Purpose of this to make the process faster rather than appending the whole goal as we just need to count.
                                                      self.goalFinishedList.append("1")
                                                  }
                                              }

                                            }
                                    

                                           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                               self.completedGoalCount = self.goalFinishedList.count
                                            print(self.totalGoalCount)
                                               print(self.completedGoalCount,"completed goals")
                                               if self.completedGoalCount != 0 {
                                                   self.percent = String(format: "%.2f", Double(self.completedGoalCount) / Double(self.totalGoalCount))
                                               }else{
                                                   self.percent = "0"
                                               }
                                               print("testing squat\(self.todaySquat)")
                                                //var completedGoalCount = 0
                                           
                                    
                                     
                                            //print(Float(self.percent))
                                              self.CircularProgress.setProgressWithAnimation(duration: 0.0, value: Float(self.percent)!)
                                                self.goalCompletedLabel.text = "\(self.completedGoalCount)/\(self.totalGoalCount) goals completed"
                                              
                                           }
                                       
                               }
                      
        }
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if functionCalling != 0 {
            authorizeAndGetHealthKit()
            loadGoalData()
        }else{
            functionCalling = functionCalling + 1
        }
  
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
