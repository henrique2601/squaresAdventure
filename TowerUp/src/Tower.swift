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
            FloorType(maxDeathCount: 0, maxTime: 20, minCoins: 0),//0
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//1
            FloorType(maxDeathCount: 0, maxTime: 30, minCoins: 0),//2
            FloorType(maxDeathCount: 0, maxTime: 25, minCoins: 0),//3
            FloorType(maxDeathCount: 0, maxTime: 50, minCoins: 0),//4
            FloorType(maxDeathCount: 0, maxTime: 40, minCoins: 0),//5
            FloorType(maxDeathCount: 0, maxTime: 40, minCoins: 0),//6
            FloorType(maxDeathCount: 0, maxTime: 30, minCoins: 0),//7
            FloorType(maxDeathCount: 0, maxTime: 100, minCoins: 0),//8
            FloorType(maxDeathCount: 0, maxTime: 50, minCoins: 0),//9
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//10
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//11
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//12
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//13
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//14
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//15
            FloorType(maxDeathCount: 0, maxTime: 25, minCoins: 0),//16
            FloorType(maxDeathCount: 0, maxTime: 35, minCoins: 0),//17
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//18
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0) //19
            ])),
        
        TowerType(tileset:"sand", floorTypes: Array<FloorType>([
            FloorType(maxDeathCount: 0, maxTime: 10, minCoins: 0),//0
            FloorType(maxDeathCount: 0, maxTime: 8, minCoins: 0),//1
            FloorType(maxDeathCount: 0, maxTime: 10, minCoins: 0),//2
            FloorType(maxDeathCount: 0, maxTime: 8, minCoins: 0),//3
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//4
            FloorType(maxDeathCount: 0, maxTime: 10, minCoins: 0),//5
            FloorType(maxDeathCount: 0, maxTime: 6, minCoins: 0),//6
            FloorType(maxDeathCount: 0, maxTime: 12, minCoins: 0),//7
            FloorType(maxDeathCount: 0, maxTime: 9, minCoins: 0),//8
            FloorType(maxDeathCount: 0, maxTime: 9, minCoins: 0),//9
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//10
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//11
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//12
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//13
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//14
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//15
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//16
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//17
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0),//18
            FloorType(maxDeathCount: 0, maxTime: 15, minCoins: 0) //19
            ])),
        
        TowerType(tileset:"cake", floorTypes: Array<FloorType>([
            FloorType(maxDeathCount: 1, maxTime: 10, minCoins: 0),//0
            FloorType(maxDeathCount: 2, maxTime: 15, minCoins: 0),//1
            FloorType(maxDeathCount: 3, maxTime: 20, minCoins: 0),//2
            FloorType(maxDeathCount: 4, maxTime: 25, minCoins: 0),//3
            FloorType(maxDeathCount: 5, maxTime: 30, minCoins: 0),//4
            FloorType(maxDeathCount: 6, maxTime: 35, minCoins: 0),//5
            FloorType(maxDeathCount: 7, maxTime: 40, minCoins: 0),//6
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//7
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//8
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//9
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//10
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//11
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//12
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//13
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//14
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//15
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//16
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//17
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0),//18
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 0) //19
            ])),
        
        TowerType(tileset:"castle", floorTypes: Array<FloorType>([
            FloorType(maxDeathCount: 1, maxTime: 10, minCoins: 10),//0
            FloorType(maxDeathCount: 2, maxTime: 15, minCoins: 20),//1
            FloorType(maxDeathCount: 3, maxTime: 20, minCoins: 30),//2
            FloorType(maxDeathCount: 4, maxTime: 25, minCoins: 40),//3
            FloorType(maxDeathCount: 5, maxTime: 30, minCoins: 50),//4
            FloorType(maxDeathCount: 6, maxTime: 35, minCoins: 60),//5
            FloorType(maxDeathCount: 7, maxTime: 40, minCoins: 70),//6
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//7
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//8
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//9
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//10
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//11
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//12
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//13
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//14
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//15
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//16
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//17
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//18
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44) //19
            ])),
        
        TowerType(tileset:"choco", floorTypes: Array<FloorType>([
            FloorType(maxDeathCount: 1, maxTime: 10, minCoins: 10),//0
            FloorType(maxDeathCount: 2, maxTime: 15, minCoins: 20),//1
            FloorType(maxDeathCount: 3, maxTime: 20, minCoins: 30),//2
            FloorType(maxDeathCount: 4, maxTime: 25, minCoins: 40),//3
            FloorType(maxDeathCount: 5, maxTime: 30, minCoins: 50),//4
            FloorType(maxDeathCount: 6, maxTime: 35, minCoins: 60),//5
            FloorType(maxDeathCount: 7, maxTime: 40, minCoins: 70),//6
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//7
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//8
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//9
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//10
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//11
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//12
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//13
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//14
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//15
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//16
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//17
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44),//18
            FloorType(maxDeathCount: 1, maxTime: 15, minCoins: 44) //19
            ]))
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
