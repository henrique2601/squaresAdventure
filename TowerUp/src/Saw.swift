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
    
    static var animation:SKAction = {
        let textures = [
            SKTexture(imageNamed: "sawHalf"),
            SKTexture(imageNamed: "sawHalf_move")
        ]
        return SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/60 * 4))
    }()
    
    init(x:Int, y:Int) {
        super.init(imageName: "sawHalf", x: x, y: y)
        
        self.run(Saw.animation)
        
        let mask = SKTexture(imageNamed: "sawHalf")//TODO: criar mask
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: mask, alphaThreshold: 0.7, size: mask.size())
        } else {
            // Fallback on earlier versions
            self.physicsBody = SKPhysicsBody(rectangleOf: mask.size())
        }
        
        self.physicsBody!.categoryBitMask = physicsCategory.saw.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.isDynamic = false
        
        self.physicsBody!.restitution = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
