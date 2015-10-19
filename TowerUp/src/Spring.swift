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
        super.init(imageName: "spring", x: x, y: y)
        
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
