//
//  BoxCrate.swift
//  TowerUp
//
//  Created by Pablo Henrique on 24/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class BoxCrate: Tile {
    
    init(x:Int, y:Int) {
        super.init(imageName: "boxCrate", x: x, y: y)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 64, height: 64))
        
        self.physicsBody!.categoryBitMask = physicsCategory.boxCrate.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask =
            physicsCategory.ground.rawValue |
            physicsCategory.spike.rawValue |
            physicsCategory.spring.rawValue |
            physicsCategory.player.rawValue |
            physicsCategory.boxCrate.rawValue
        self.physicsBody!.dynamic = true
        
        self.physicsBody!.linearDamping = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
