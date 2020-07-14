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
        bg.position = CGPoint(x: self.size.width, y: self.size.height)
        bg.zPosition = 0
        self.addChild(bg)
    }
}
