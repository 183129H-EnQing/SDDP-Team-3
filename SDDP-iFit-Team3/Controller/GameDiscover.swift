//
//  GameDiscover.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/18/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameDiscover: SKScene {
    
    var playerFitness = 10
    var playerPlanets = 10
    var playerTroops = 10
    var playerScore = 10
    
    override func didMove(to view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "lightspeed")
        bg.size = CGSize(width: self.size.width, height: self.size.height)
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bg.zPosition = 0
        self.addChild(bg)
        
        let rocketboost = SKSpriteNode(imageNamed: "rocketboost")
        rocketboost.size = CGSize(width: self.size.width * 0.2, height: self.size.height * 0.15)
        rocketboost.position = CGPoint(x: self.size.width * 0.7, y: self.size.height/4)
        rocketboost.zPosition = 1
        self.addChild(rocketboost)
        
        let resultText = SKLabelNode(fontNamed: "The Bold Font")
        resultText.text = "JUMPING TO LIGHTSPEED..."
        resultText.fontSize = 60
        resultText.fontColor = SKColor.white
        resultText.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.8)
        resultText.zPosition = 1
        self.addChild(resultText)
        
        delay(3.0) {
            self.discoverPlanet()
        }
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func discoverPlanet(){
        let sceneChange = GameHome(size: self.size)
        let transition = SKTransition.fade(withDuration: 0.5)
        sceneChange.scaleMode = self.scaleMode
        sceneChange.playerFitness = playerFitness
        sceneChange.playerPlanets = playerPlanets
        sceneChange.playerTroops = playerTroops
        sceneChange.playerScore = playerScore
        self.view!.presentScene(sceneChange, transition: transition)
    }
}
