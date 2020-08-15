//
//  Game.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/18/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import Foundation

class Game: NSObject {
    var armyCount: Int
    var planets: Int
    var userId: String
    var points: Int     //research
    var score: Int      //leaderboard
    
    init(armyCount: Int, planets: Int, userId: String, points: Int, score: Int){
        self.armyCount = armyCount
        self.planets = planets
        self.userId = userId
        self.points = points
        self.score = score
    }
}
