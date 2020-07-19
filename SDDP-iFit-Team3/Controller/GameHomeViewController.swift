//
//  GameHomeViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/14/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit
import SpriteKit

class GameHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        var playerGameData: Game = Game(armyCount: 0, planets: [""], userId: "")
//        if let user = UserAuthentication.getLoggedInUser() {
//            DataManager.GamesClass.loadGames(userId: user.uid) { (data) in
//
//                if data.userId != "" {
//                    playerGameData = data
//                    print("data")
//                }
//            }
//        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameHome.sks'
            let scene = GameHome(size: CGSize(width: 1536, height: 2048))
            //            if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
             var playerGameData: Game = Game(armyCount: 0, planets: [""], userId: "")
            if let user = UserAuthentication.getLoggedInUser() {
                DataManager.GamesClass.loadGames(userId: user.uid) { (data) in
                    
                    if data.userId != "" {
                        playerGameData = data
                        print("hiii VC DATAAA: ", playerGameData.armyCount)
                        scene.userData?.setObject(playerGameData.armyCount, forKey: "playerarmyCount" as NSCopying)
                    }
                }
            }
            
            // Present the scene
            view.presentScene(scene)
            //            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
