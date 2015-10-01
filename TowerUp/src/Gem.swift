//
//  Gem.swift
//  TowerUp
//
//  Created by Pablo Henrique on 24/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Gem: Coin {
    
    override init(type:String, x:Int, y:Int) {
        super.init(imageName: "gem\(type)", x: x, y: y)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 32, height: 32))
        
        self.physicsBody!.categoryBitMask = physicsCategory.gem.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.ground.rawValue | physicsCategory.gem.rawValue
        
        self.physicsBody!.dynamic = false
        
        self.bonus = 1
        
        Coin.coinList.addObject(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
