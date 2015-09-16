//
//  PowerUp.swift
//  TowerUp
//
//  Created by Pablo Henrique on 28/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class PowerUp: SKSpriteNode {
    
    static var powerUpList = Set<PowerUp>()
    
    var powerUpData:PowerUpData
    
    var inUse:Bool = false {
        didSet {
            if(self.inUse) {
                var spriteNode = SKSpriteNode(imageNamed: PowerUps.types.last!.buttonImage)
                spriteNode.color = GameColors.black
                spriteNode.colorBlendFactor = 1
                spriteNode.zPosition = self.zPosition + CGFloat(1)
                self.addChild(spriteNode)
            } else {
                self.removeAllChildren()
            }
        }
    }
    
    init(powerUpData:PowerUpData) {
        self.powerUpData = powerUpData
        
        let powerUpType = PowerUps.types[powerUpData.index.integerValue]
        
        let texture = SKTexture(imageNamed: powerUpType.buttonImage)
        super.init(texture: texture, color: nil, size: texture.size())
        
        self.name = powerUpData.index.description
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
//        self.name = name
//        self.position = CGPoint(x: x/2 + Int(Config.translate.x), y: -y/2 - Int(Config.translate.y))
//        self.zPosition = Config.HUDZPosition
//        
//        let texture0 = SKTexture(imageNamed: "\(textureName)0")
//        let switch0 = SKSpriteNode(texture: texture0, color: nil, size: texture0.size())
//        switch0.anchorPoint = CGPoint(x: 0, y: 1)
//        switch0.name = "\(name)0"
//        self.addChild(switch0)
//        
//        let texture1 = SKTexture(imageNamed: "\(textureName)1")
//        let switch1 = SKSpriteNode(texture: texture1, color: nil, size: texture1.size())
//        switch1.anchorPoint = CGPoint(x: 0, y: 1)
//        switch1.name = "\(name)1"
//        switch1.hidden = true
//        self.addChild(switch1)
//        
//        PowerUp.powerUpList.insert(self)
//    }
    
//    class func update(currentTime: NSTimeInterval) {
//        for powerUp in PowerUp.powerUpList {
//            //powerUp.update(currentTime:currentTime)
//            
//        }
//    }
    
    //    private func update(currentTime: NSTimeInterval) {
    //
    //    }
    
//    override class func update() {
//        for powerUp in PowerUp.powerUpList {
//            var i = 0
//            for touch in Control.touchesArray {
//                let location = touch.locationInNode(powerUp.parent)
//                if powerUp.containsPoint(location) {
//                    i++
//                }
//            }
//            if(i > 0) {
//                powerUp.buttonPressed()
//            } else {
//                powerUp.buttonReleased()
//            }
//        }
//    }
}

class PowerUpType: NSObject {
    var buttonImage:String
    var coolDown:NSTimeInterval
    var price:Int
    
    init(buttonImage:String, price:Int, coolDown:NSTimeInterval) {
        self.buttonImage = buttonImage
        self.coolDown = coolDown
        self.price = price
    }
}

class PowerUps :NSObject {
    static var types = Array<PowerUpType>([
        PowerUpType(buttonImage:"powerUp A", price:120, coolDown:1),
        PowerUpType(buttonImage:"powerUp B", price:110, coolDown:2),
        PowerUpType(buttonImage:"powerUp C", price:100, coolDown:3),
        PowerUpType(buttonImage:"powerUp D", price:90, coolDown:4),
        PowerUpType(buttonImage:"powerUp E", price:80, coolDown:5),
        PowerUpType(buttonImage:"powerUp F", price:70, coolDown:6),
        PowerUpType(buttonImage:"powerUp G", price:60, coolDown:7),
        PowerUpType(buttonImage:"powerUp H", price:50, coolDown:8),
        PowerUpType(buttonImage:"powerUp I", price:40, coolDown:9),
        PowerUpType(buttonImage:"powerUp J", price:30, coolDown:10),
        PowerUpType(buttonImage:"powerUp K", price:20, coolDown:11),
        PowerUpType(buttonImage:"powerUp L", price:10, coolDown:12)
        ])
}
