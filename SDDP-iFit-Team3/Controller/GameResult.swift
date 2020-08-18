//
//  GameResult.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/15/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameResult: SKScene {
    
    var playerFitness = 10
    var playerPlanets = 10
    var playerTroops = 10
    var playerScore = 10
    
    var battleResult : Bool = true //true = won, false = lost
    var result : String = ""
    var bg : String = ""
    
    var enemyTroop = 0
    
    override func didMove(to view: SKView) {
        
        if battleResult == false {
            result = "DEFEAT"
            bg = "grave"
        }
        else {
            result = "VICTORY"
            bg = "raiseflag"
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
        
        //
        let closeButton = SKSpriteNode(imageNamed: "yellowbutton")
        closeButton.name = "homeButton"
        closeButton.size = CGSize(width: 80, height: 80)
        closeButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.85)
        closeButton.zPosition = 2
        self.addChild(closeButton)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          for touch: AnyObject in touches {
              
              let pointOfTouch = touch.location(in: self)
              for nodeTapped in nodes(at: pointOfTouch) {
                  
                  let transition = SKTransition.fade(withDuration: 0.5)
                  
                if nodeTapped.name == "homeButton"{
                    let sceneChange = GameHome(size: self.size)
                    sceneChange.scaleMode = self.scaleMode
                    sceneChange.playerFitness = playerFitness
                    sceneChange.playerPlanets = playerPlanets
                    sceneChange.playerTroops = playerTroops
                    sceneChange.playerScore = playerScore
                      self.view!.presentScene(sceneChange, transition: transition)
                  }
              }
          }
      }
}
