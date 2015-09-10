//
//  WinTile.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/18/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class DoorTile: Tile {
    init(type:String, x:Int, y:Int) {
        super.init(imageName: "winTile", x: x, y: y)//TODO: door vai mudar de acordo com o tipo de torre?
        
        self.name = "doorTile"
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 32, height: 32))
        
        self.physicsBody!.categoryBitMask = physicsCategory.doorTile.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
