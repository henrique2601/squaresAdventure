//
//  PowerUpSlot.swift
//  TowerUp
//
//  Created by Pablo Henrique on 10/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class PowerUpSlot: SKSpriteNode {
    
    var empty:Bool = true
    var powerUpType:PowerUpType!
    
    init() {
        let texture = SKTexture(imageNamed: "powerUpSlot")
        super.init(texture: texture, color: nil, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPowerUp(index:Int) {
        self.powerUpType = PowerUps.types[index]
        self.addChild(SKSpriteNode(imageNamed: self.powerUpType.buttonImage))
        self.empty = false
    }
    
    func reset() {
        self.removeAllChildren()
        self.empty = true
    }
}
