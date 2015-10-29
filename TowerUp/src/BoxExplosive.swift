//
//  BoxExplosive.swift
//  Squares Adventure
//
//  Created by Pablo Henrique on 27/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class BoxExplosive: Tile {
    
    init(position:CGPoint) {
        
        let positionX = position.x
        let positionY = position.y
        
        let tileX = Int(round(positionX / Tile.sizeInPoints))
        let tileY = Int(round(positionY / Tile.sizeInPoints))
        
        super.init(imageName: "boxExplosive_disabled", position: CGPoint(x: tileX * Int(Tile.sizeInPoints), y: tileY * Int(Tile.sizeInPoints)))
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 64, height: 64))
        
        self.physicsBody!.categoryBitMask = physicsCategory.boxExplosiveDisabled.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.restitution = 4
        
        self.physicsBody!.dynamic = false
        
        self.zPosition = Config.HUDZPosition - 1
    }
    
    func activate() {
        self.texture = SKTexture(imageNamed: "boxExplosive")
        self.physicsBody!.categoryBitMask = physicsCategory.boxExplosive.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
