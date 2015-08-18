//
//  WinTile.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/18/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class WinTile: Tile {
    init(type:String, x:Int, y:Int) {
        super.init(imageName: "winTile", x: x, y: y)//TODO: winTile vai mudar de acordo com o tipo de torre
        
        self.name = "winTile"
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 32, height: 32))
        
        self.physicsBody!.categoryBitMask = physicsCategory.winTile.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.25)
    }
    
    init(type:String, id:Int, x:Int, y:Int) {
        super.init(imageName: type + String(id), x: x, y: y)
        
        self.name = "ground"
        
        self.physicsBody = SKPhysicsBody(bodies: [MapManager.bodies[id - 1]])
        
        self.physicsBody!.categoryBitMask = physicsCategory.ground.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
