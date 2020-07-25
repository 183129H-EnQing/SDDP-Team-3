//
//  TrainingPlanStartViewController.swift
//  SDDP-iFit-Team3
//
//  Created by ITP312Grp1 on 13/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
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
    return String(format: "%\(f)fu", self)
  }
}

class TrainingPlanStartViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var previewView: UIImageView!
    var lastExecution = Date()

    @IBOutlet weak var fpsLabel: UILabel!
    @IBOutlet weak var modelIdLabel: UILabel!
    @IBOutlet weak var modelVersionLabel: UILabel!

//    lazy var poseModel = FritzVisionHumanPoseModelFast(model: PoseEstimationFast1595485568().fritz())
//    let predictor = FritzVisionPosePredictor<CustomSkeleton>(model: PoseEstimationFast1595485568().fritz())
    let poseModel = FritzVisionPosePredictor<CustomSkeleton>(model: PoseEstimationFast1595485568().fritz())
    
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
        guard let rotated = image.rotated() else { return }
        
        let image = UIImage(pixelBuffer: rotated as! CVPixelBuffer)
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
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let image = FritzVisionImage(sampleBuffer: sampleBuffer, connection: connection)
        
        image.metadata = FritzVisionImageMetadata()
        image.metadata?.orientation = .left
        
        let options = FritzVisionPoseModelOptions()
        options.minPartThreshold = 0.3
        options.minPoseThreshold = 0.3
        
        
       guard let result = try? poseModel.predict(image, options: options)
//             ,let pose = poseResult.pose()
        else {
                // If there was no pose, display original image
                displayInputImage(image)
                return
        }
        
        updateLabels()
        
        guard let pose = result.pose() else {
            return
        }

        let leftArm: [Keypoint<CustomSkeleton>] = [
            pose.getKeypoint(for: .leftWrist),
            pose.getKeypoint(for: .leftElbow),
            pose.getKeypoint(for: .leftShoulder)
        ].compactMap { $0 }

        let rightArm: [Keypoint<CustomSkeleton>] = [
            pose.getKeypoint(for: .rightWrist),
            pose.getKeypoint(for: .rightElbow),
            pose.getKeypoint(for: .rightShoulder)
        ].compactMap { $0 }
        
        guard let poseResult = image.draw(pose: pose) else {
          displayInputImage(image)
          return
        }

        DispatchQueue.main.async {
          self.previewView.image = poseResult
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

