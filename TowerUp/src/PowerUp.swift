//
//  PowerUp.swift
//  TowerUp
//
//  Created by Pablo Henrique on 28/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class PowerUp: Button {
    
    static var powerUpList = Set<PowerUp>()
    
    var powerUpData:PowerUpData
    
    var powerUp:SKSpriteNode!
    var powerUpPressed:SKSpriteNode!
    
    var powerUpShadow:SKSpriteNode!
    var powerUpPressedShadow:SKSpriteNode!
    
    var inUse:Bool = false {
        didSet {
            if(self.inUse) {
                self.powerUpShadow.hidden = false
                self.powerUpPressedShadow.hidden = false
            } else {
                self.powerUpShadow.hidden = true
                self.powerUpPressedShadow.hidden = true
            }
        }
    }
    
    init(powerUpData:PowerUpData) {
        self.powerUpData = powerUpData
        super.init()
        self.load()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load() {
        let name:String = powerUpData.index.description
        self.name = name
        
        let powerUpType = PowerUps.types[powerUpData.index.integerValue]
        
        let texture = SKTexture(imageNamed: powerUpType.powerUpImage)
        self.powerUp = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.powerUpShadow = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.powerUpShadow.color = GameColors.black
        self.powerUpShadow.colorBlendFactor = 1
        self.powerUpShadow.hidden = true
        
        self.powerUp.addChild(Label(name: "labelPrice", color: GameColors.black, textureName: powerUpType.price.description, x: 0, y: 31))
        self.powerUp.name = name
        self.addChild(self.powerUp)
        self.powerUp.addChild(self.powerUpShadow)
        
        let texturePressed = SKTexture(imageNamed: "\(powerUpType.powerUpImage)Pressed")
        self.powerUpPressed = SKSpriteNode(texture: texturePressed, color: UIColor.whiteColor(), size: texturePressed.size())
        self.powerUpPressedShadow = SKSpriteNode(texture: texturePressed, color: UIColor.whiteColor(), size: texturePressed.size())
        self.powerUpPressedShadow.color = GameColors.black
        self.powerUpPressedShadow.colorBlendFactor = 1
        self.powerUpPressedShadow.hidden = true
        
        self.powerUpPressed.addChild(Label(name: "labelPrice", color: GameColors.black, textureName: powerUpType.price.description, x: 0, y: 31 + 2))
        self.powerUpPressed.name = "\(name)Pressed"
        self.powerUpPressed.hidden = true
        self.addChild(self.powerUpPressed)
        self.powerUpPressed.addChild(self.powerUpPressedShadow)
        
        PowerUp.powerUpList.insert(self)
    }
    
    override class func update(touches: Set<UITouch>) {
        for powerUp in PowerUp.powerUpList {
            if let event = powerUp.event {
                for touch in touches {
                    if let parent = powerUp.parent {
                        let location = touch.locationInNode(parent)
                        if powerUp.containsPoint(location) {
                            event.raise()
                        }
                    }
                }
            }
            powerUp.update()
        }
    }
    
    override class func update() {
        for powerUp in PowerUp.powerUpList {
            powerUp.update()
        }
    }
    
    override func update() {
        var i = 0
        for touch in Control.touchesArray {
            if let parent = self.parent {
                let location = touch.locationInNode(parent)
                if self.containsPoint(location) {
                    i++
                }
            }
        }
        if(i > 0) {
            self.powerUpPresse()
        } else {
            self.powerUpRelease()
        }
    }
    
    func powerUpPresse() {
        self.pressed = true
        self.powerUp.hidden = true
        self.powerUpPressed.hidden = false
    }
    
    func powerUpRelease() {
        self.pressed = false
        self.powerUp.hidden = false
        self.powerUpPressed.hidden = true
    }
    
    override func removeFromParent() {
        PowerUp.powerUpList.remove(self)
        super.removeFromParent()
    }
}

class PowerUpType: NSObject {
    var powerUpImage:String
    var coolDown:NSTimeInterval
    var price:Int
    
    init(powerUpImage:String, price:Int, coolDown:NSTimeInterval) {
        self.powerUpImage = powerUpImage
        self.coolDown = coolDown
        self.price = price
    }
}

class PowerUps :NSObject {
    static var types = Array<PowerUpType>([
        PowerUpType(powerUpImage:"powerUp A", price:120, coolDown:1),
        PowerUpType(powerUpImage:"powerUp B", price:110, coolDown:2),
        PowerUpType(powerUpImage:"powerUp C", price:100, coolDown:3),
        PowerUpType(powerUpImage:"powerUp D", price:90, coolDown:4),
        PowerUpType(powerUpImage:"powerUp E", price:80, coolDown:5),
        PowerUpType(powerUpImage:"powerUp F", price:70, coolDown:6),
        PowerUpType(powerUpImage:"powerUp G", price:60, coolDown:7),
        PowerUpType(powerUpImage:"powerUp H", price:50, coolDown:8),
        PowerUpType(powerUpImage:"powerUp I", price:40, coolDown:9),
        PowerUpType(powerUpImage:"powerUp J", price:30, coolDown:10),
        PowerUpType(powerUpImage:"powerUp K", price:20, coolDown:11),
        PowerUpType(powerUpImage:"powerUp L", price:10, coolDown:12)
        ])
}
