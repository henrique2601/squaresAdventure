//
//  Shot.swift
//  Squares Adventure
//
//  Created by Pablo Henrique Bertaco on 11/9/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import SpriteKit

class Shot: SKSpriteNode {
    
    init(shotDirection:CGVector) {
        
        let texture = SKTexture(imageNamed: "shot")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 32)
        
        self.physicsBody!.categoryBitMask = physicsCategory.bullet.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.restitution = 2
        
        self.physicsBody!.velocity = CGVector(dx: shotDirection.dx * 10, dy: shotDirection.dy * 10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
