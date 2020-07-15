//
//  GameHome.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/14/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameHome: SKScene {
    
    override func didMove(to view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "space")
        bg.size = self.size
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bg.zPosition = 0
        self.addChild(bg)
        
        let earth = SKSpriteNode(imageNamed: "earth")
        earth.size = CGSize(width: 800, height: 800)
        earth.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        earth.zPosition = 1
        self.addChild(earth)
        
        let rocket = SKSpriteNode(imageNamed: "rocket")
        rocket.size = CGSize(width: 170, height: 200)
        rocket.position = CGPoint(x: self.size.width/2 * 1.4, y: self.size.height * 0.8)
        rocket.zPosition = 2
        self.addChild(rocket)
        
        let tank = SKSpriteNode(imageNamed: "tank")
        tank.size = CGSize(width: 200, height: 200)
        tank.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.15)
        tank.zPosition = 2
        self.addChild(tank)
        
        let battleButton = SKSpriteNode(imageNamed: "yellowbutton")
        battleButton.name = "battleButton"
        battleButton.size = CGSize(width: 400, height: 150)
        battleButton.position = CGPoint(x: self.size.width * 0.37, y: self.size.height * 0.27)
        battleButton.zPosition = 2
        battleButton.setScale(0.9)
        self.addChild(battleButton)
        
        let battleText = SKLabelNode(fontNamed: "The Bold Font")
        battleText.text = "BATTLE"
        battleText.fontSize = 65
        battleText.fontColor = SKColor.black
        battleText.position = CGPoint(x: self.size.width * 0.37, y: self.size.height * 0.252)
        battleText.zPosition = 3
        self.addChild(battleText)
        
        let researchButton = SKSpriteNode(imageNamed: "yellowbutton")
        researchButton.name = "researchButton"
        researchButton.size = CGSize(width: 400, height: 150)
        researchButton.position = CGPoint(x: self.size.width * 0.63, y: self.size.height * 0.27)
        researchButton.zPosition = 2
        researchButton.setScale(0.9)
        self.addChild(researchButton)
        
        let researchText = SKLabelNode(fontNamed: "The Bold Font")
        researchText.text = "RESEARCH"
        researchText.fontSize = 55
        researchText.fontColor = SKColor.black
        researchText.position = CGPoint(x: self.size.width * 0.63, y: self.size.height * 0.255)
        researchText.zPosition = 3
        self.addChild(researchText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            for nodeTapped in nodes(at: pointOfTouch) {
                
                let transition = SKTransition.fade(withDuration: 0.5)
                
                if nodeTapped.name == "battleButton"{
                    let sceneChange = GameScene(size: self.size)
                    sceneChange.scaleMode = self.scaleMode
                    self.view!.presentScene(sceneChange, transition: transition)
                }
                
                
                if nodeTapped.name == "researchButton"{
                    let sceneChange = GameResearch(size: self.size)
                    sceneChange.scaleMode = self.scaleMode
                    self.view!.presentScene(sceneChange, transition: transition)
                }
            }
        }
    }
    
}
