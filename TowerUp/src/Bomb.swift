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
    
    static var bombList = Array<Bomb>()
    var listPosition: Int!
    
    init(x:Int, y:Int) {
        super.init(imageName: "bomb", x: x, y: y)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
        
        self.physicsBody!.categoryBitMask = physicsCategory.bomb.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        self.color = UIColor.black
        self.colorBlendFactor = 0.2
        self.physicsBody!.restitution = 4
        
        self.physicsBody!.isDynamic = false
        
        if (Bomb.bombList.count > 0) {
            self.listPosition = (Bomb.bombList.last?.listPosition)! + 1
        }
            
        else {
            self.listPosition = 0
        }
        
        
        Bomb.bombList.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func removeFromParent() {
        
        let particles = SKEmitterNode(fileNamed: "Bomb.sks")!
        
        particles.position.x = self.position.x
        particles.position.y = self.position.y
        particles.zPosition = self.zPosition
        
        if let parent = self.parent {
            parent.addChild(particles)
            
            let action = SKAction()
            action.duration = 2
            particles.run(action , completion: {
                particles.removeFromParent()
            })
        }
        
        for i in (0 ..< Bomb.bombList.count).reversed() {
            if (Bomb.bombList[i].listPosition == self.listPosition){
                Bomb.bombList.remove(at: i)
            }
        }
        super.removeFromParent()
        
    }
    
}
