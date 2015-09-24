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
    
    override init(imageName:String, x:Int, y:Int) {
        super.init(imageName: imageName, x: x, y: y)
    }
    
    init(type:String, x:Int, y:Int) {
        super.init(imageName: "coin\(type)", x: x, y: y)
        
        self.name = "coin"
        
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
