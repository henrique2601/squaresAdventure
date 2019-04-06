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
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        
        self.physicsBody!.categoryBitMask = physicsCategory.bullet.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.ground.rawValue
        self.physicsBody!.collisionBitMask =
            physicsCategory.ground.rawValue |
            physicsCategory.player.rawValue
            
        
        self.physicsBody!.restitution = 2
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.affectedByGravity = false
        
        self.physicsBody!.velocity = CGVector(dx: shotDirection.dx * 750, dy: shotDirection.dy * 750)
        
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody, contact:SKPhysicsContact) {
        self.removeFromParent()
    }
}
