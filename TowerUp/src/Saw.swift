//
//  Saw.swift
//  Squares Adventure
//
//  Created by Pablo Henrique on 08/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Saw: Tile {
    init(x:Int, y:Int) {
        super.init(imageName: "sawHalf", x: x, y: y)
        
        let mask = SKTexture(imageNamed: "spikesMask")
        self.physicsBody = SKPhysicsBody(texture: mask, alphaThreshold: 0.7, size: mask.size())
        
        self.physicsBody!.categoryBitMask = physicsCategory.saw.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
        
        self.physicsBody!.restitution = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
