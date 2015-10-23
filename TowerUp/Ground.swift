//
//  Ground.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Ground: Tile {
   static var typeCount = 64
    
    init(type:String, id:Int, x:Int, y:Int) {
        super.init(imageName: type + String(id), x: x, y: y)
        
        self.name = "ground"
        
        self.physicsBody = SKPhysicsBody(bodies: [MapManager.bodies[id - 1]])
        
        self.physicsBody!.categoryBitMask = physicsCategory.ground.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
    }
    
    init(type:String, imageName:String, x:Int, y:Int) {
        super.init(imageName: imageName, x: x, y: y)
        
        self.name = "ground"
        let texture = SKTexture(imageNamed: imageName)
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.7,  size: texture.size())
        } else {
            // Fallback on earlier versions
            self.physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        }
        
        self.physicsBody!.categoryBitMask = physicsCategory.ground.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.dynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
