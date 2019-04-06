//
//  Spring.swift
//  TowerUp
//
//  Created by Pablo Henrique on 24/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Spring: Tile {
    
    var doingLogic = false
    
    lazy var animation:SKAction = {
        let textures = [
            SKTexture(imageNamed: "spring1")
        ]
        return SKAction.animate(with: textures, timePerFrame: 0.5)
    }()
    
    lazy var endAnimation:SKAction = {
        SKAction.setTexture(SKTexture(imageNamed: "spring0"))
    }()
    
    init(x:Int, y:Int) {
        super.init(imageName: "spring0", x: x, y: y)
        
        let mask = SKTexture(imageNamed: "springMask")
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: mask, size: mask.size())
        } else {
            // Fallback on earlier versions
            self.physicsBody = SKPhysicsBody(rectangleOf: mask.size())
        }
        
        self.physicsBody!.categoryBitMask = physicsCategory.spring.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.isDynamic = false
        
        self.physicsBody!.restitution = 2
    }
    
    func doLogic(player:Player) {
        if (self.doingLogic == false) {
            
            if(player.position.y > self.position.y) {
                self.doingLogic = true
                
                player.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 25))
                player.physicsBody!.angularVelocity = self.physicsBody!.angularVelocity/2
                player.physicsBody!.velocity.dx = self.physicsBody!.velocity.dx/2
                
                self.run(self.animation, completion: { () -> Void in
                    self.doingLogic = false
                    self.run(self.endAnimation)
                })
                
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
