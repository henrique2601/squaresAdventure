//
//  GameMath.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit

class GameMath: NSObject {
    
    class func isTowerUnlocked(lastFloorUnlocked:Int, towerIndex:Int) -> Bool {
        return (lastFloorUnlocked - 1) / 10 >= towerIndex
    }
}
