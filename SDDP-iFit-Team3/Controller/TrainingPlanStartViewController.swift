//
//  TrainingPlanStartViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 13/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import Fritz

public enum BodySkeleton: Int, SkeletonType {
    public static let objectName = "Body"

    case nose
    case leftEye
    case rightEye
    case leftEar
    case rightEar
    case leftShoulder
    case rightShoulder
    case leftElbow
    case rightElbow
    case leftWrist
    case rightWrist
    case leftHip
    case rightHip
    case leftKnee
    case rightKnee
    case leftAnkle
    case rightAnkle
}

class FritzVisionPosePredictor<T>{
    // Register your model with the Fritz SDK
    extension PoseEstimationFast1595485568: SwiftIdentifiedModel {
        static let modelIdentifier = "a4228ab365cd4dc9aa8d33ad52be5906"
        static let packagedModelVersion = 2
    }

    // Create the predictor
    let BodyPoseModel = FritzVisionPosePredictor<BodySkeleton>(
        model: PoseEstimationFast1595485568()
    )
}

extension Double {
  func format(f: String) -> String {
    return String(format: "%\(f)f", self)
  }
}

class TrainingPlanStartViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var previewView: UIImageView!
    var lastExecution = Date()
    
    @IBOutlet weak var fpsLabel: UILabel!
    @IBOutlet weak var modelIdLabel: UILabel!
    @IBOutlet weak var modelVersionLabel: UILabel!
    
    public static let objectName = "Mixed sSquat"
    
    lazy var poseModel = FritzVisionHumanPoseModelFast(model: PoseEstimationFast1595485568().fritz())
    
    
    // We can also set of sensitivity parameters for our model.
    // The poseThreshold is a number between 0 and 1. Higher numbers mean
    // the model must be more confident about its estimate, thus reducing false
    // positives.
    internal var poseThreshold: Double = 0.3
    
    lazy var poseSmoother = PoseSmoother<OneEuroPointFilter, HumanSkeleton>()
    
    // Confidence thresholds define the minimum threshold required to show a pose (i.e. an entire skeleton)
    // as well as the minimum threshold to include a part (i.e. an arm) in a given pose.
    let minPoseThreshold = 0.4
    let minPartThreshold = 0.5
    
    private lazy var captureSession: AVCaptureSession = {
      let session = AVCaptureSession()

      guard
        let backCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
          for: .video,
          position: .back),
        let input = try? AVCaptureDeviceInput(device: backCamera)
        else { return session }
      session.addInput(input)

      session.sessionPreset = .photo
      return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add preview View as a subview
        previewView = UIImageView(frame: view.bounds)
        previewView.contentMode = .scaleAspectFill
        view.addSubview(previewView)
        view.bringSubviewToFront(fpsLabel)
        view.bringSubviewToFront(modelIdLabel)
        view.bringSubviewToFront(modelVersionLabel)
        fpsLabel.textAlignment = .center
        modelIdLabel.textAlignment = .center
        modelVersionLabel.textAlignment = .center

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA as UInt32]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        self.captureSession.addOutput(videoOutput)
        self.captureSession.startRunning()
    }
    
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()

      previewView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }

    func displayInputImage(_ image: FritzVisionImage) {
      guard let rotated = image.rotate() else { return }

      let image = UIImage(pixelBuffer: rotated)
      DispatchQueue.main.async {
        self.previewView.image = image
      }
    }
    
    func updateLabels() {
      let thisExecution = Date()
      let executionTime = thisExecution.timeIntervalSince(self.lastExecution)
      let framesPerSecond: Double = 1 / executionTime
      self.lastExecution = thisExecution
      
      DispatchQueue.main.async {
        self.fpsLabel.text = "FPS: \(framesPerSecond.format(f: ".3"))"
        self.modelIdLabel.text = "Model ID: \(self.poseModel.managedModel.activeModelConfig.identifier)"
        self.modelVersionLabel.text = "Active Version: \(self.poseModel.managedModel.activeModelConfig.version)"
      }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let image = FritzVisionImage(sampleBuffer: sampleBuffer, connection: connection)
        let options = FritzVisionPoseModelOptions()
        options.minPoseThreshold = minPoseThreshold
        options.minPartThreshold = minPartThreshold
        
        guard let result = try? poseModel.predict(image, options: options) else {
            // If there was no pose, display original image
            displayInputImage(image)
            return
        }
        
        // To record predictions and send data back to Fritz AI via the Data Collection System, use the predictors's record method.
        // In addition to the input image, predicted model results can be collected as well as user-modified annotations.
        // This allows developers to both gather data on model performance and have users collect additional ground truth data for future model retraining.
        // Note, the Data Collection System is only available on paid plans.
        // poseModel.record(image, predicted: result.poses(), modified: nil)
        
        updateLabels()
        
        guard let pose = result.pose() else {
            displayInputImage(image)
            return
        }
        
        // Uncomment to use pose smoothing to smoothe output of model.
        // Will increase lag of pose a bit.
        // pose = poseSmoother.smoothe(pose)
        
        guard let poseResult = image.draw(pose: pose) else {
            displayInputImage(image)
            return
        }
        
        DispatchQueue.main.async {
            self.previewView.image = poseResult
        }
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

