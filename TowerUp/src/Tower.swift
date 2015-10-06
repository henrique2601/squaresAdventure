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
        TowerType(tileset:"grass", floorTypes: Array<FloorType>([
            FloorType(maxDeathCount: 1, maxTime: 10, minCoins: 10),
            FloorType(maxDeathCount: 2, maxTime: 15, minCoins: 20),
            FloorType(maxDeathCount: 3, maxTime: 20, minCoins: 30),
            FloorType(maxDeathCount: 4, maxTime: 25, minCoins: 40),
            FloorType(maxDeathCount: 5, maxTime: 30, minCoins: 50),
            FloorType(maxDeathCount: 6, maxTime: 35, minCoins: 60),
            FloorType(maxDeathCount: 7, maxTime: 40, minCoins: 70),
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44)
            ])),
        
        TowerType(tileset:"sand", floorTypes: Array<FloorType>([
            FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80),
            FloorType(maxDeathCount: 9, maxTime: 50, minCoins: 90)
            ]))
        
        /*,
        TowerType(tileset:"cake", floorTypes: Array<FloorType>([
        FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80)
        ])),
        
        TowerType(tileset:"castle", floorTypes: Array<FloorType>([
        FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80)
        ])),
        
        TowerType(tileset:"choco", floorTypes: Array<FloorType>([
        FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80)
        ])),
        
        TowerType(tileset:"dirt", floorTypes: Array<FloorType>([
        FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80)
        ])),
        
        TowerType(tileset:"metal", floorTypes: Array<FloorType>([
        FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80)
        ])),
        
        TowerType(tileset:"purple", floorTypes: Array<FloorType>([
        FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80)
        ])),
        
        TowerType(tileset:"snow", floorTypes: Array<FloorType>([
        FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80)
        ])),
        
        TowerType(tileset:"tundra", floorTypes: Array<FloorType>([
        FloorType(maxDeathCount: 8, maxTime: 45, minCoins: 80)
        ]))
        */
        
        ])
}

class TowerType: NSObject {
    
    var tileset:String!
    
    var floorTypes:Array<FloorType>!
    
    init(tileset:String, floorTypes:Array<FloorType>) {
        super.init()
        self.tileset = tileset
        self.floorTypes = floorTypes
    }
}

class FloorType: NSObject {
    var maxDeathCount:Int!
    var maxTime:Int!
    var minCoins:Int!
    
    init(maxDeathCount:Int, maxTime:Int, minCoins:Int) {
        super.init()
        self.maxDeathCount = maxDeathCount
        self.maxTime = maxTime
        self.minCoins = minCoins
    }
}
