//
//  Tower.swift
//  TowerUp
//
//  Created by Pablo Henrique on 03/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Tower: Control {
    
}

class Towers: NSObject {
    static var types = Array<TowerType>([
        TowerType(floorCount: 7),
        TowerType(floorCount: 3),
        TowerType(floorCount: 2),
        TowerType(floorCount: 10),
        ])
}

class TowerType: NSObject {
    
    var floorCount:Int!
    
    init(floorCount:Int) {
        super.init()
        self.floorCount = floorCount
    }
}


