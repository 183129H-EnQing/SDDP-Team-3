//
//  GamePlanet.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/19/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GamePlanet: SKScene {
    
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
        
        let planetText = SKLabelNode(fontNamed: "The Bold Font")
        planetText.text = "PLANETS"
        planetText.fontSize = 65
        planetText.fontColor = SKColor.white
        planetText.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.85)
        planetText.zPosition = 2
        self.addChild(planetText)
        
        //
        let earth = SKSpriteNode(imageNamed: "earth")
        earth.size = CGSize(width: self.size.width * 0.2, height: self.size.height * 0.15)
        earth.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.7)
        earth.zPosition = 1
        self.addChild(earth)
        
        let fireball = SKSpriteNode(imageNamed: "earth")
        fireball.size = CGSize(width: self.size.width * 0.2, height: self.size.height * 0.15)
        fireball.position = CGPoint(x: self.size.width * 0.65, y: self.size.height * 0.7)
        fireball.zPosition = 1
        self.addChild(fireball)
        
        let earthText = SKLabelNode(fontNamed: "The Bold Font")
        earthText.text = "Earth"
        earthText.fontSize = 45
        earthText.fontColor = SKColor.white
        earthText.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.6)
        earthText.zPosition = 1
        self.addChild(earthText)
        
        let fireballText = SKLabelNode(fontNamed: "The Bold Font")
        fireballText.text = "Fireball"
        fireballText.fontSize = 45
        fireballText.fontColor = SKColor.white
        fireballText.position = CGPoint(x: self.size.width * 0.65, y: self.size.height * 0.6)
        fireballText.zPosition = 1
        self.addChild(fireballText)
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
