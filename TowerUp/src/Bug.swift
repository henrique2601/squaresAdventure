//
//  Bug.swift
//  TowerUp
//
//  Created by Pablo Henrique on 24/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Bug: Tile {
    init(x:Int, y:Int) {
        super.init(imageName: "bug", x: x, y: y)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
        
        self.physicsBody!.categoryBitMask = physicsCategory.none.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        
        self.physicsBody!.isDynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
