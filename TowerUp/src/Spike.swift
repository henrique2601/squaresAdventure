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
        let texture = SKTexture(imageNamed: "spikes")//Só vai ter um tipo de spike?
        super.init(texture: texture, color: nil, size: texture.size())
        self.position = CGPoint(x: x * (Int)(Tile.sizeInPoints), y: y * -(Int)(Tile.sizeInPoints) + (Int)(Chunk.sizeInPoints - Tile.sizeInPoints))
        
        self.name = "spike"
        
        let mask = SKTexture(imageNamed: "spikesMask")
        self.physicsBody = SKPhysicsBody(texture: mask, alphaThreshold: 0.7, size: mask.size())
        
        self.physicsBody!.categoryBitMask = physicsCategory.spike.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
