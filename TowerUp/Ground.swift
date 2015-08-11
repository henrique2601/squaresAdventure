//
//  Ground.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Ground: Tile {
   static var typeCount = 18
    
    init(type:String, id:Int, x:Int, y:Int) {
        super.init(imageName: type + String(id), x: x, y: y)
        
        self.physicsBody = SKPhysicsBody(bodies: [MapManager.bodies[id - 1]])
        self.physicsBody!.dynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
