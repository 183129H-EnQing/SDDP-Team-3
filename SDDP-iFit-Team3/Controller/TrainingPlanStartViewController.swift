//
//  TrainingPlanStartViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 13/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import Photos
import Fritz

public enum CustomSkeleton: Int, SkeletonType {
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

extension Double {
  func format(f: String) -> String {
    return String(format: "%\(f)f", self)
  }
}

class TrainingPlanStartViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var previewView: UIImageView!
    var lastExecution = Date()

    @IBOutlet weak var fpsLabel: UILabel!
    @IBOutlet weak var modelIdLabel: UILabel!
    @IBOutlet weak var modelVersionLabel: UILabel!
    
    lazy var poseModel = FritzVisionHumanPoseModelFast()
    //var poseModel = FritzVisionPosePredictor<CustomSkeleton>(
    //model: PoseEstimationFast1595485568
    //)
    // To use your own pose estimation model, following instructions here:
    // https://docs.fritz.ai/develop/vision/pose-estimation/custom-pose-estimation/ios.html

//    lazy var poseModel = FritzVisionHumanPoseModelFast(model: PoseEstimationFast1595485568().fritz())
//    let poseModel = FritzVisionPosePredictor<CustomSkeleton>(model: PoseEstimationFast1595485568().fritz())
//    let poseModel = FritzVisionPosePredictor<CustomSkeleton>(model: PoseEstimationFast1595485568().fritz())
    
    // We can also set of sensitivity parameters for our model.
    // The poseThreshold is a number between 0 and 1. Higher numbers mean
    // the model must be more confident about its estimate, thus reducing false
    // positives.
//    internal var poseThreshold: Double = 0.3

    lazy var poseSmoother = PoseSmoother<OneEuroPointFilter, HumanSkeleton>()

    // Confidence thresholds define the minimum threshold required to show a pose (i.e. an entire skeleton)
    // as well as the minimum threshold to include a part (i.e. an arm) in a given pose.
    let minPoseThreshold = 0.4
    let minPartThreshold = 0.4

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

//      print("add input for session")
      session.sessionPreset = .photo
      return session
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        print("start of init")
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
//        print("running init")
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
        
//        print("displaying input image")
        let image = UIImage(pixelBuffer: rotated)
        DispatchQueue.main.async {
            self.previewView.image = image
//            print("image showing")
        }
    }

    func updateLabels() {
//        print("update labels")
      let thisExecution = Date()
      let executionTime = thisExecution.timeIntervalSince(self.lastExecution)
      let framesPerSecond: Double = 1 / executionTime
      self.lastExecution = thisExecution

      DispatchQueue.main.async {
//          print("update labels async")
        self.fpsLabel.text = "FPS: \(framesPerSecond.format(f: ".3"))"
        self.modelIdLabel.text = "Model ID: \(self.poseModel.managedModel.activeModelConfig.identifier)"
        self.modelVersionLabel.text = "Active Version: \(self.poseModel.managedModel.activeModelConfig.version)"
//        print("showing labels")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
//        print("capturing output")
        let image = FritzVisionImage(sampleBuffer: sampleBuffer, connection: connection)
        
        image.metadata = FritzVisionImageMetadata()
        image.metadata?.orientation = .right
        
        let options = FritzVisionPoseModelOptions()
        options.minPoseThreshold = minPoseThreshold
        options.minPartThreshold = minPartThreshold
        
        //
        
        guard let result = try? poseModel.predict(image, options: options)
            //             ,let pose = poseResult.pose()
            else {
                // If there was no pose, display original image
                displayInputImage(image)
                return
        }
        
        updateLabels()
        
        //result.
        guard let pose = result.pose() else {
            displayInputImage(image)
            return
        }
        
//        let leftArm: [Keypoint<CustomSkeleton>] = [
//            pose.getKeypoint(for: .leftWrist),
//            pose.getKeypoint(for: .leftElbow),
//            pose.getKeypoint(for: .leftShoulder)
//            ].compactMap { $0 }
//
//        let rightArm: [Keypoint<CustomSkeleton>] = [
//            pose.getKeypoint(for: .rightWrist),
//            pose.getKeypoint(for: .rightElbow),
//            pose.getKeypoint(for: .rightShoulder)
//            ].compactMap { $0 }
        
        
        guard let poseResult = image.draw(pose: pose) else {
            displayInputImage(image)
            return
        }
        
        DispatchQueue.main.async {
            self.previewView.image = poseResult
        }
    }
}

