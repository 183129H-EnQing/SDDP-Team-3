//
//  GameResult.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/15/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameResult: SKScene {
    
    let battleResult = false //true = won, false = lost
    var result = "VICTORY"
    var bg = "raiseflag"
    
    override func didMove(to view: SKView) {
        
        if battleResult == false{
            result = "DEFEAT"
            bg = "grave"
        }
        
        let bg = SKSpriteNode(imageNamed: self.bg)
        bg.size = CGSize(width: self.size.width * 0.75, height: self.size.height * 0.82)
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.49)
        bg.zPosition = 0
        self.addChild(bg)
        
        let resultText = SKLabelNode(fontNamed: "The Bold Font")
        resultText.text = result
        resultText.fontSize = 80
        resultText.fontColor = SKColor.white
        resultText.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.8)
        resultText.zPosition = 1
        self.addChild(resultText)
    }
}
