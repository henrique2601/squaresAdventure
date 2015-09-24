//
//  Spring.swift
//  TowerUp
//
//  Created by Pablo Henrique on 24/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Spring: Tile {
    
    init(x:Int, y:Int) {
        let texture = SKTexture(imageNamed: "spring")//Só vai ter um tipo de spike?
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.position = CGPoint(x: x * (Int)(Tile.sizeInPoints), y: y * -(Int)(Tile.sizeInPoints) + (Int)(Chunk.sizeInPoints - Tile.sizeInPoints))
        
        let mask = SKTexture(imageNamed: "springMask")
        self.physicsBody = SKPhysicsBody(texture: mask, alphaThreshold: 0.7, size: mask.size())
        
        self.physicsBody!.categoryBitMask = physicsCategory.spring.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
        
        self.physicsBody!.restitution = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
