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
    var powerUpSlotData:PowerUpSlotData
    
//    init() {
//        let texture = SKTexture(imageNamed: "powerUpSlot")
//        super.init(texture: texture, color: nil, size: texture.size())
//    }
    
    init(powerUpSlotData:PowerUpSlotData) {
        self.powerUpSlotData = powerUpSlotData
        
        let texture = SKTexture(imageNamed: "powerUpSlot")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        if let powerUpData = powerUpSlotData.powerUp {
            self.setPowerUp(powerUpData: powerUpData)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setPowerUp(index:Int) {
//        for powerUpData in MemoryCard.sharedInstance.playerData.powerUps as! Set<PowerUpData> {
//            if(powerUpData.index.integerValue == index) {
//                self.powerUpSlotData.powerUp = powerUpData
//                self.powerUpType = PowerUps.types[index]
//                self.addChild(SKSpriteNode(imageNamed: self.powerUpType.buttonImage))
//                self.empty = false
//            }
//        }
//    }
    
    func setPowerUp(powerUpData:PowerUpData) {
        self.powerUpSlotData.powerUp = powerUpData
        let powerUpType = PowerUps.types[powerUpData.index.intValue]
        let spriteNode = SKSpriteNode(imageNamed: powerUpType.powerUpImage)
        spriteNode.zPosition = self.zPosition + 1
        self.addChild(spriteNode)
        self.addChild(Label(text: powerUpType.price.description, x: 0, y: 31))
        self.empty = false
    }
    
    func reset() {
        self.powerUpSlotData.powerUp = nil//Quebrando referencia entre o Slot e o PowerUp
        self.removeAllChildren()
        self.empty = true
    }
}
