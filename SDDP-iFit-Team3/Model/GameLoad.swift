//
//  GameLoad.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/15/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameLoad: SKScene {
    
    var playerFitness = 10
    var playerPlanets = 10
    var playerTroops = 10
    
    var battleResult = false
    var enemyTroops = 0
    
    override func didMove(to view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "stormtrooper")
        bg.size = CGSize(width: self.size.width * 0.75, height: self.size.height * 0.82)
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.49)
        bg.zPosition = 0
        self.addChild(bg)
        
        let battle = SKLabelNode(fontNamed: "The Bold Font")
        battle.text = "BATTLE  LOADING..."
        battle.fontSize = 80
        battle.fontColor = SKColor.white
        battle.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.8)
        battle.zPosition = 1
        self.addChild(battle)
        
        let quote = SKLabelNode(fontNamed: "The Bold Font")
        quote.text = "Fire at will!"
        quote.fontSize = 40
        quote.fontColor = SKColor.white
        quote.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        quote.zPosition = 1
        self.addChild(quote)
        
        let quote1 = SKLabelNode(fontNamed: "The Bold Font")
        quote1.text = "Commander Zex"
        quote1.fontSize = 40
        quote1.fontColor = SKColor.white
        quote1.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.16)
        quote1.zPosition = 1
        self.addChild(quote1)
        
        createFight()
        
        delay(3.0) {
            self.launchAttack()
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func launchAttack(){
        
        let sceneChange = GameResult(size: self.size)
        let transition = SKTransition.fade(withDuration: 0.5)
        sceneChange.scaleMode = self.scaleMode
        sceneChange.playerFitness = playerFitness
        sceneChange.playerPlanets = playerPlanets
        sceneChange.playerTroops = playerTroops
        sceneChange.battleResult = battleResult
        sceneChange.enemyTroop = enemyTroops
        self.view!.presentScene(sceneChange, transition: transition)
    }
    
    func createFight(){     //+- 5 of player armyCount
        let random = arc4random_uniform(2)
        let randomTroops = arc4random_uniform(5)
        enemyTroops = playerTroops
        
//        print("random \(random)")
        
        if random == 1 {        //win
            enemyTroops -= Int(randomTroops)
            battleResult = true
        }
        else {                  //lose
            enemyTroops += Int(randomTroops)
            battleResult = false
        }
    }
}
