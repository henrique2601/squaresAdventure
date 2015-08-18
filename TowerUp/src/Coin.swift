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
    
    static var list:NSMutableArray = NSMutableArray()
    
    var bonus = 1//Valor da moeda
    
    init(type:String, x:Int, y:Int) {
        super.init(imageName: "coin\(type)", x: x, y: y)
        
        self.name = "coin"
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        
        self.physicsBody!.categoryBitMask = physicsCategory.coin.rawValue
        self.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        self.physicsBody!.collisionBitMask = physicsCategory.ground.rawValue | physicsCategory.coin.rawValue
        
        self.physicsBody!.dynamic = false
        
        Coin.list.addObject(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if DEBUG
    override func removeFromParent() {
        super.removeFromParent()
        if(Coin.list.containsObject(self)) {
            NSException.raise("Use Coin.list.remove... antes de removeFromParent para evitar vazamento de memória.", format: "", arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer<Void>()))
        }
    }
    #endif
}
