//
//  GameResearch.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/14/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameResearch: SKScene {
    
    override func didMove(to view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "space")
        bg.size = self.size
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bg.zPosition = 0
        self.addChild(bg)
        
        let closeButton = SKSpriteNode(imageNamed: "yellowbutton")
        closeButton.name = "homeButton"
        closeButton.size = CGSize(width: 80, height: 80)
        closeButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.85)
        closeButton.zPosition = 2
        self.addChild(closeButton)
        
        let research = SKLabelNode(fontNamed: "The Bold Font")
        research.text = "RESEARCH"
        research.fontSize = 65
        research.fontColor = SKColor.white
        research.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.85)
        research.zPosition = 2
        self.addChild(research)
        
        //
        let bg1 = SKSpriteNode(imageNamed: "bluegrid")
        bg1.size = CGSize(width: self.size.width, height: self.size.height * 0.32)
        bg1.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.65)
        bg1.zPosition = 1
        self.addChild(bg1)
        
        let rocket = SKSpriteNode(imageNamed: "rocket")
        rocket.size = CGSize(width: 250, height: 250)
        rocket.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.66)
        rocket.zPosition = 2
        self.addChild(rocket)
        
        let upgrade = SKLabelNode(fontNamed: "The Bold Font")
        upgrade.text = "UPGRADES"
        upgrade.fontSize = 65
        upgrade.fontColor = SKColor.white
        upgrade.position = CGPoint(x: self.size.width * 0.6, y: self.size.height * 0.75)
        upgrade.zPosition = 2
        self.addChild(upgrade)
        //
        
        let tank = SKSpriteNode(imageNamed: "tank")
        tank.size = CGSize(width: 250, height: 250)
        tank.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.3)
        tank.zPosition = 2
        self.addChild(tank)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            for nodeTapped in nodes(at: pointOfTouch) {
                
                let transition = SKTransition.fade(withDuration: 0.5)
                
                if nodeTapped.name == "homeButton"{
                    let sceneChange = GameHome(size: self.size)
                    sceneChange.scaleMode = self.scaleMode
                    self.view!.presentScene(sceneChange, transition: transition)
                }
            }
        }
    }
}
