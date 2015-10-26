//
//  Coin.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/18/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Coin: Tile {
    
    static var coinList:NSMutableArray = NSMutableArray()
    
    var bonus = 1//Valor da moeda
    
    static var animation:SKAction = {
        let textures = [
            SKTexture(imageNamed: "gold_1"),
            SKTexture(imageNamed: "gold_2"),
            SKTexture(imageNamed: "gold_3"),
            SKTexture(imageNamed: "gold_4"),
            SKTexture(imageNamed: "gold_5"),
            SKTexture(imageNamed: "gold_6")
        ]
        return SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 1/60 * 4))
    }()
    
    override init(imageName:String, x:Int, y:Int) {
        super.init(imageName: imageName, x: x, y: y)
    }
    
    init(type:String, x:Int, y:Int) {
        super.init(imageName: "gold_1", x: x, y: y)
        self.runAction(Coin.animation)
        
        self.name = "coin"
        
        self.zPosition = Config.HUDZPosition - CGFloat(1)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 32, height: 32))
        
        self.physicsBody!.categoryBitMask = physicsCategory.coin.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.ground.rawValue | physicsCategory.coin.rawValue
        
        self.physicsBody!.dynamic = false
        
        Coin.coinList.addObject(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromParent() {
        Coin.coinList.removeObject(self)
        super.removeFromParent()
    }
}
