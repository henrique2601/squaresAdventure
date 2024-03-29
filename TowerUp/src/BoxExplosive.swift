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
    
    static var boxExplosiveList = Array<BoxExplosive>()
    var listPosition: Int!
    var creator: String!
    
    init(position:CGPoint) {
        
        print("criei a bomba")
        
        let positionX = position.x
        let positionY = position.y
        
        let tileX = Int(round(positionX / Tile.sizeInPoints))
        let tileY = Int(round(positionY / Tile.sizeInPoints))
        
        super.init(imageName: "boxExplosive_disabled", position: CGPoint(x: tileX * Int(Tile.sizeInPoints), y: tileY * Int(Tile.sizeInPoints)))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
        
        self.physicsBody!.categoryBitMask = physicsCategory.boxExplosiveDisabled.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.restitution = 4
        
        self.physicsBody!.isDynamic = false
        
        self.zPosition = Config.HUDZPosition - 1
        
        if (BoxExplosive.boxExplosiveList.count > 0) {
            self.listPosition = (BoxExplosive.boxExplosiveList.last?.listPosition)! + 1
        }
        
        else {
            self.listPosition = 0
        }
        

        BoxExplosive.boxExplosiveList.append(self)
    }
    
    func activate() {
        self.texture = SKTexture(imageNamed: "boxExplosive")
        self.physicsBody!.categoryBitMask = physicsCategory.boxExplosive.rawValue
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
                
        for i in 0 ..< BoxExplosive.boxExplosiveList.count {
            if (BoxExplosive.boxExplosiveList[i].listPosition == self.listPosition) {
         
                BoxExplosive.boxExplosiveList.remove(at: i)
                //break usado para evitar continuar enumerando a lista apos ela ter sido alterada.
                break
            }
        }
        
        
        super.removeFromParent()
    }
}
