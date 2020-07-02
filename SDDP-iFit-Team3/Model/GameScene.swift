//
//  GameScene.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/2/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "pull_string")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let player = SKSpriteNode(imageNamed: "pull_string")
        player.setScale(1)
        player.position = CGPoint()
    }
}

