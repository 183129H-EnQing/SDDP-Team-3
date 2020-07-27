//
//  SpeechSynthesizer.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/26/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//
import UIKit
import AVFoundation

class SpeechSynthesizer {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    var voice = AVSpeechSynthesisVoice(language: "en-GB")
    
    func say(_ phrase: String){
        
//        guard UIAccessibility.isVoiceOverRunning else { return }
        
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.rate = rate
        utterance.voice = voice
        
        synthesizer.speak(utterance)
    }
    
    func getVoices(){
        AVSpeechSynthesisVoice.speechVoices().forEach({ print($0.language)})
    }
}
