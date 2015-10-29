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
        
        let mask = SKTexture(imageNamed: "spikesMask")
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: mask, alphaThreshold: 0.7, size: mask.size())
        } else {
            // Fallback on earlier versions
            self.physicsBody = SKPhysicsBody(rectangleOfSize: mask.size())        }
        
        self.physicsBody!.categoryBitMask = physicsCategory.spike.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        self.color = UIColor.blackColor()
        self.colorBlendFactor = 0.2
        self.physicsBody!.dynamic = false
        
        self.physicsBody!.restitution = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
