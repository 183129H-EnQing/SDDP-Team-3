//
//  TrainingPlanStartViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 13/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import Fritz

class TrainingPlanStartViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var previewView: UIImageView!
    
//    lazy var poseModel = FritzVisionHumanPoseModelFast()
    
    // We can also set of sensitivity parameters for our model.
    // The poseThreshold is a number between 0 and 1. Higher numbers mean
    // the model must be more confident about its estimate, thus reducing false
    // positives.
    internal var poseThreshold: Double = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//           // FritzVisionImage objects offer convient ways to manipulate
//           // images used as input to machine learning models.
//           // You can resize, crop, and scale images to your needs.
//           let image = FritzVisionImage(sampleBuffer: sampleBuffer, connection: connection)
//
//           // Set options for our pose estimation model using the constants
//           // we initialized earlier in the ViewController.
//           let options = FritzVisionPoseModelOptions()
//           options.minPoseThreshold = poseThreshold
//
//           // Run the model itself on an input image.
//           guard let poseResult = try? poseModel.predict(image, options: options) else {
//               if let rotated = image.rotate() {
//                   let img = UIImage(pixelBuffer: rotated)
//                   DispatchQueue.main.async {
//                       self.previewView.image = img
//                   }
//               }
//               return
//           }
//           let poses = poseResult.poses()
//           
//           DispatchQueue.main.async {
//               self.cameraView.image = image.draw(poses: poses)
//           }
//       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

