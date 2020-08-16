//
//  GameLeaderboard.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 8/16/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit
import UIKit

class GameTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    var items: [String] = ["Player1", "Player2", "Player3"]
    
    //retrieve all players score
    //DataManager.GamesClass.loadAllGame { (data) in
        
        
    //}
    //sort their score
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}

class GameLeaderboard: SKScene {
    
    var playerFitness = 10
    var playerPlanets = 10
    var playerTroops = 10
    var playerScore = 10
    
    var gameTableView = GameTable()
    private var label : SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 1.0))
        }
        // Table setup
        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        gameTableView.frame = CGRect(x: 20, y: 180, width: 380, height:200)
        self.scene?.view?.addSubview(gameTableView)
        gameTableView.reloadData()
        
        //
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
        
        let lbText = SKLabelNode(fontNamed: "The Bold Font")
        lbText.text = "LEADERBOARD"
        lbText.fontSize = 80
        lbText.fontColor = SKColor.white
        lbText.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.83)
        lbText.zPosition = 1
        self.addChild(lbText)
        //
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
