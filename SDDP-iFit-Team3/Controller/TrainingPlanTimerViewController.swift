//
//  TrainingPlanTimerViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/25/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class TrainingPlanTimerViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
//    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent}
    
    var isTimerOn = false
    var timer = Timer()
    
    var duration = 30
    
    let speechSyntehsizer = SpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        speechSyntehsizer.getVoices()
        
        timeLabel.text = String(duration)
        
        playButton.setImage(UIImage(named: "playIcon"), for: .normal)
        playButton.backgroundColor = .green
        
        resetButton.setImage(UIImage(named: "resetIcon"), for: .normal)
        resetButton.backgroundColor = .red
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
    }
    
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        isTimerOn = true
        toggleTimer(on: isTimerOn)
        playButton.isEnabled = false
        resetButton.isEnabled = false
        
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        speechSyntehsizer.say("Reseting Timer")
        duration = 30
        timeLabel.text = String(duration)
        
        playButton.isEnabled = true
        
        //for pause and play
//        playButton.setImage(UIImage(named: "playIcon"), for: .normal)
//        playButton.backgroundColor = .green
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
