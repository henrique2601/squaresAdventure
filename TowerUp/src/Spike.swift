//
//  Spike.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/18/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Spike: Tile {
    init(x:Int, y:Int) {
        super.init(imageName: "spikes", x: x, y: y)
        
        self.name = "spike"
        
        let mask = SKTexture(imageNamed: "spikesMask")
        self.physicsBody = SKPhysicsBody(texture: mask, alphaThreshold: 0.7, size: mask.size())
        
        self.physicsBody!.categoryBitMask = physicsCategory.spike.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
        
        self.physicsBody!.restitution = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
