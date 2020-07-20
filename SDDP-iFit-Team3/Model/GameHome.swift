//
//  GameHome.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/14/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameHome: SKScene {
    
    var playerFitness = 10
    var playerPlanets = 10
    var playerTroops = 10
    
    var planetsList = ["earth", "fireball", "redcrater", "desert", "cat"]
    
    override func didMove(to view: SKView) {
        self.userData?.setObject("HELLO", forKey: "a" as NSCopying)
        
        if let playerarmyCount = self.userData?.value(forKey: "armyCount"){
//            print("GMAEINOOOOO: ", playerarmyCount)
            
            playerTroops = Int((playerarmyCount as! NSString).doubleValue)
        }
        if let playerplanetCount = self.userData?.value(forKey: "planetCount"){
            
            playerPlanets = Int((playerplanetCount as! NSString).doubleValue)
        }
//        print("OIIIII")
        
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
        rocket.size = CGSize(width: 180, height: 200)
        rocket.position = CGPoint(x: self.size.width/2 * 1.4, y: self.size.height * 0.7)
        rocket.zPosition = 2
        self.addChild(rocket)
        
        let tank = SKSpriteNode(imageNamed: "tank")
        tank.size = CGSize(width: 200, height: 200)
        tank.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.15)
        tank.zPosition = 2
        self.addChild(tank)
        
        //
        let battleButton = SKSpriteNode(imageNamed: "yellowbutton")
        battleButton.name = "battleButton"
        battleButton.size = CGSize(width: 400, height: 150)
        battleButton.position = CGPoint(x: self.size.width * 0.37, y: self.size.height * 0.27)
        battleButton.zPosition = 2
        battleButton.setScale(0.9)
        self.addChild(battleButton)
        
        let battleText = SKLabelNode(fontNamed: "The Bold Font")
        battleText.text = "BATTLE"
        battleText.fontSize = 55
        battleText.fontColor = SKColor.black
        battleText.position = CGPoint(x: self.size.width * 0.37, y: self.size.height * 0.255)
        battleText.zPosition = 3
        self.addChild(battleText)
        
        let researchButton = SKSpriteNode(imageNamed: "bluebutton")
        researchButton.name = "researchButton"
        researchButton.size = CGSize(width: 400, height: 150)
        researchButton.position = CGPoint(x: self.size.width * 0.63, y: self.size.height * 0.27)
        researchButton.zPosition = 2
        researchButton.setScale(0.9)
        self.addChild(researchButton)
        
        let researchText = SKLabelNode(fontNamed: "The Bold Font")
        researchText.text = "RESEARCH"
        researchText.fontSize = 55
        researchText.fontColor = SKColor.white
        researchText.position = CGPoint(x: self.size.width * 0.63, y: self.size.height * 0.255)
        researchText.zPosition = 3
        self.addChild(researchText)
        
        let discoverButton = SKSpriteNode(imageNamed: "yellowbutton")
        discoverButton.name = "discoverButton"
        discoverButton.size = CGSize(width: 220, height: 250)
        discoverButton.position = CGPoint(x: self.size.width * 0.74, y: self.size.height * 0.14)
        discoverButton.zPosition = 2
        self.addChild(discoverButton)
        
        let discoverImg = SKSpriteNode(imageNamed: "rocket")
        discoverImg.size = CGSize(width: 100, height: 100)
        discoverImg.position = CGPoint(x: self.size.width * 0.74, y: self.size.height * 0.13)
        discoverImg.zPosition = 3
        self.addChild(discoverImg)
        //
        
        //
        let finessIcon = SKSpriteNode(imageNamed: "barbell")
        finessIcon.size = CGSize(width: 100, height: 100)
        finessIcon.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.85)
        finessIcon.zPosition = 2
        self.addChild(finessIcon)
        
        let fitnessText = SKLabelNode(fontNamed: "The Bold Font")
        fitnessText.text = "\(playerFitness)"
        fitnessText.fontSize = 60
        fitnessText.fontColor = SKColor.white
        fitnessText.position = CGPoint(x: self.size.width * 0.33, y: self.size.height * 0.84)
        fitnessText.zPosition = 2
        self.addChild(fitnessText)
        //
        
        //
        let planetIcon = SKSpriteNode(imageNamed: "earth")
        planetIcon.size = CGSize(width: 100, height: 100)
        planetIcon.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.85)
        planetIcon.zPosition = 2
        self.addChild(planetIcon)
        
        let planetText = SKLabelNode(fontNamed: "The Bold Font")
        planetText.text = "\(playerPlanets)"
        planetText.fontSize = 60
        planetText.fontColor = SKColor.white
        planetText.position = CGPoint(x: self.size.width * 0.67, y: self.size.height * 0.84)
        planetText.zPosition = 2
        self.addChild(planetText)
        
        let troopsIcon = SKSpriteNode(imageNamed: "tank1")
        troopsIcon.size = CGSize(width: 100, height: 100)
        troopsIcon.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.8)
        troopsIcon.zPosition = 2
        self.addChild(troopsIcon)
        
        let troopsText = SKLabelNode(fontNamed: "The Bold Font")
        troopsText.text = "\(playerTroops)"
        troopsText.fontSize = 60
        troopsText.fontColor = SKColor.white
        troopsText.position = CGPoint(x: self.size.width * 0.67, y: self.size.height * 0.79)
        troopsText.zPosition = 2
        self.addChild(troopsText)
        //
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            for nodeTapped in nodes(at: pointOfTouch) {
                
                let transition = SKTransition.fade(withDuration: 0.5)
                
                if nodeTapped.name == "battleButton"{
                    let sceneChange = GameLoad(size: self.size)
                    sceneChange.scaleMode = self.scaleMode
                    self.view!.presentScene(sceneChange, transition: transition)
                }
                
                
                if nodeTapped.name == "researchButton"{
                    let sceneChange = GameResearch(size: self.size)
                    sceneChange.scaleMode = self.scaleMode
                    self.view!.presentScene(sceneChange, transition: transition)
                }
                
                if nodeTapped.name == "discoverButton"{
                    
//                    var playerNextPlanet = playerPlanets + 1
//                    var sufficientCost = false
//                    var planetCost = 0
//
//                    switch playerPlanets{
//                    case 2: planetCost = 10
//                    case 3: planetCost = 25
//                    case 4: planetCost = 50
//                    default:
//                        planetCost = 100
//                    }
//
//                    if playerFitness >= planetCost {
//                        sufficientCost = true
//
//
//                    }
//                    else {
//                        print("gg u need do more fit")
//                    }
                    let sceneChange = GamePlanet(size: self.size)
                    sceneChange.scaleMode = self.scaleMode
                    sceneChange.playerFitness = playerFitness
                    sceneChange.playerPlanets = playerPlanets
                    sceneChange.playerTroops = playerTroops
                    self.view!.presentScene(sceneChange, transition: transition)
                }
            }
        }
    }
    
    
}
