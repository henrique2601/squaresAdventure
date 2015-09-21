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
        TowerType(floorCount: 7, tileset:"grass"),
        TowerType(floorCount: 2, tileset:"dirt")
        ])
}

class TowerType: NSObject {
    
    var floorCount:Int!
    var tileset:String!
    
    init(floorCount:Int, tileset:String) {
        super.init()
        self.floorCount = floorCount
        self.tileset = tileset
    }
}


