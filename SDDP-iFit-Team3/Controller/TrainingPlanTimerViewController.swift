//
//  TrainingPlanTimerViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import SafariServices

class TrainingPlanTimerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var exitButton: UIButton!
    //    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent}
    
    var isTimerOn = false
    var timer = Timer()
    var duration = 30
    var isVoiceOn = true

    let speechSyntehsizer = SpeechSynthesizer()
    
    var trainingPlan: TrainingPlan?
    var exerciseList : [Exercise] = []
    
    var maxOneRep = 0
    var currentReps = 0
    var currentRepsExercise = 0
    
    var skipsNo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadExercise()
//        print(exerciseList)
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Training Plan"
        
        let imageButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(imageValidation))
        let soundButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(isSoundEnabled))
        self.navigationItem.rightBarButtonItems = [imageButton, soundButton]
        
//        speechSyntehsizer.getVoices()
        
        timeLabel.text = String(duration)
        
//        playButton.setImage(UIImage(named: "playIcon"), for: .normal)
//        playButton.backgroundColor = .green
//        
//        
//        resetButton.setImage(UIImage(named: "resetIcon"), for: .normal)
//        resetButton.backgroundColor = .red
    }
    
    func loadExercise(){
        DataManager.ExerciseClass.loadExercises { (data) in
            
            if data.count > 0 {
                self.exerciseList = data
                
                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
                    self.exerciseName.text = self.trainingPlan?.tpExercises[self.currentRepsExercise]
                    self.maxOneRep = self.trainingPlan?.tpExercises.count as! Int
                    print("hi", self.maxOneRep)
                    self.matchExerciseImage()
                }
            }
        }
    }
    
    func matchExerciseImage(){
        for i in exerciseList {
            print("HELLO", i)
            if exerciseName.text ==  i.exName{
                imageView.image = UIImage(named: i.exImage)
            }
        }
    }
    
    @objc func imageValidation(){
        let vc = SFSafariViewController(url: URL(string: "https://editor.p5js.org/182452K/present/EHF_lPwP6")!)
        present(vc, animated: true)
    }
    
    @objc func isSoundEnabled(){
        
        if isVoiceOn == true {
            speechSyntehsizer.say("Voice disabled")
            speechSyntehsizer.stopVoice()
            isVoiceOn = false
            
            let alertController = UIAlertController(title: "Voice Disabled", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            speechSyntehsizer.startVoice()
            speechSyntehsizer.say("Voice enabled")
            isVoiceOn = true
            
            let alertController = UIAlertController(title: "Voice Enabled", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func toggleTimer(on: Bool){
        if on {
            speechSyntehsizer.say("Starting Exercise, \(duration) seconds begin")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // your code here
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.duration -= 1
                    strongSelf.timeLabel.text = String(strongSelf.duration)
                    
                    if strongSelf.duration > 0 && strongSelf.duration % 10 == 0  {
                        self!.speechSyntehsizer.say("\(self!.duration) seconds")
                    }
                    
                    if self!.duration < 5 {
                        self!.speechSyntehsizer.say("\(self!.duration)")
                    }
                    
                    if self!.duration == 0 {
                        self!.speechSyntehsizer.say("Exercise Complete")
                        self!.isTimerOn = false
                        self!.timer.invalidate()
                        self!.resetButton.isEnabled = true
                    }
                })
            }
        }
        else {
            timer.invalidate()
        }
    }
    
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        isTimerOn = true
        toggleTimer(on: isTimerOn)
        playButton.isEnabled = false
//        resetButton.isEnabled = sfalse
        
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        speechSyntehsizer.say("Reseting Timer")
        isTimerOn = false
        toggleTimer(on: isTimerOn)
        
        duration = 30
        timeLabel.text = String(duration)
        
        playButton.isEnabled = true
        
        //for pause and play
//        playButton.setImage(UIImage(named: "playIcon"), for: .normal)
//        playButton.backgroundColor = .green
    }
    @IBAction func exitButtonPressed(_ sender: Any) {
        let exitAlert = UIAlertController(title: "Confirm Exit?", message: "Your reps might not be complete", preferredStyle: UIAlertController.Style.alert)
        
        exitAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Ok")
            self.navigationController?.popViewController(animated: true)
        }))
        
        exitAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancel")
        }))
        
        present(exitAlert, animated: true, completion: nil)
    
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
