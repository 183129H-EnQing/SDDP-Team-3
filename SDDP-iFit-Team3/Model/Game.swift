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
    var planets: [String]
    var userId: String
    
    init(armyCount: Int, planets: [String], userId: String){
        self.armyCount = armyCount
        self.planets = planets
        self.userId = userId
    }
}
