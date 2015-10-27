//
//  Bomb.swift
//  TowerUp
//
//  Created by Pablo Henrique on 24/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Bomb: Tile {
    init(x:Int, y:Int) {
        super.init(imageName: "bomb", x: x, y: y)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 64, height: 64))
        
        self.physicsBody!.categoryBitMask = physicsCategory.bomb.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        self.color = UIColor.blackColor()
        self.colorBlendFactor = 0.2
        self.physicsBody!.restitution = 4
        
        self.physicsBody!.dynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
