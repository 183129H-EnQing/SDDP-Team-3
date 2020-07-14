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
        rocket.size = CGSize(width: 150, height: 150)
        rocket.position = CGPoint(x: self.size.width/2 * 1.4, y: self.size.height * 0.25)
        rocket.zPosition = 2
        self.addChild(rocket)
        
        let tank = SKSpriteNode(imageNamed: "tank")
        tank.size = CGSize(width: 150, height: 150)
        tank.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.25)
        tank.zPosition = 2
        self.addChild(tank)
        
        let battleButton = SKSpriteNode(imageNamed: "yellowbutton")
        battleButton.name = "battleButton"
        battleButton.size = CGSize(width: 450, height: 150)
        battleButton.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.27)
        battleButton.zPosition = 2
        self.addChild(battleButton)
    }
    
}
