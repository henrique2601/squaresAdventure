//
//  Slime.swift
//  Squares Adventure
//
//  Created by Pablo Henrique on 20/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import SpriteKit

class Slime: Tile {
    init(x:Int, y:Int) {
        super.init(imageName: "slimeBlock", x: x, y: y)
        
        let mask = SKTexture(imageNamed: "slimeBlock")
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: mask, alphaThreshold: 0.7, size: mask.size())
        } else {
            // Fallback on earlier versions
            self.physicsBody = SKPhysicsBody(rectangleOfSize: mask.size())
        }
        
        self.physicsBody!.categoryBitMask = physicsCategory.slime.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask =
            physicsCategory.ground.rawValue |
            physicsCategory.spike.rawValue |
            physicsCategory.saw.rawValue |
            physicsCategory.spring.rawValue |
            physicsCategory.player.rawValue |
            physicsCategory.boxCrate.rawValue |
            physicsCategory.slime.rawValue
        self.physicsBody!.dynamic = true
        
        self.physicsBody!.linearDamping = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
