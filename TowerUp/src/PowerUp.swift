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
    
    var eventBegin:Event<Void>?// = Event()
    var eventUpdate:Event<Void>?// = Event()
    var eventEnd:Event<Void>?// = Event()
    
    var powerUpType:PowerUpType!
    
    var powerUpData:PowerUpData
    
    var powerUp:SKSpriteNode!
    var powerUpPressed:SKSpriteNode!
    
    var powerUpShadow:SKSpriteNode!
    var powerUpPressedShadow:SKSpriteNode!
    
    var lastUse:NSTimeInterval = 0
    
    var needUpdate = false
    
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
        
        self.powerUpType = PowerUps.types[powerUpData.index.integerValue]
        
        let texture = SKTexture(imageNamed: self.powerUpType.powerUpImage)
        self.powerUp = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.powerUpShadow = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.powerUpShadow.color = GameColors.black
        self.powerUpShadow.colorBlendFactor = 1
        self.powerUpShadow.hidden = true
        
        self.powerUp.addChild(Label(name: "labelPrice", color: GameColors.black, textureName: self.powerUpType.price.description, x: 0, y: 31))
        self.powerUp.name = name
        self.addChild(self.powerUp)
        self.powerUp.addChild(self.powerUpShadow)
        
        let texturePressed = SKTexture(imageNamed: "\(self.powerUpType.powerUpImage)Pressed")
        self.powerUpPressed = SKSpriteNode(texture: texturePressed, color: UIColor.whiteColor(), size: texturePressed.size())
        self.powerUpPressedShadow = SKSpriteNode(texture: texturePressed, color: UIColor.whiteColor(), size: texturePressed.size())
        self.powerUpPressedShadow.color = GameColors.black
        self.powerUpPressedShadow.colorBlendFactor = 1
        self.powerUpPressedShadow.hidden = true
        
        self.powerUpPressed.addChild(Label(name: "labelPrice", color: GameColors.black, textureName: self.powerUpType.price.description, x: 0, y: 31 + 2))
        self.powerUpPressed.name = "\(name)Pressed"
        self.powerUpPressed.hidden = true
        self.addChild(self.powerUpPressed)
        self.powerUpPressed.addChild(self.powerUpPressedShadow)
        
        PowerUp.powerUpList.insert(self)
    }
    
    func loadEvent(player:Player) {
        
        self.eventBegin = Event<Void>()
        self.eventUpdate = Event<Void>()
        self.eventEnd = Event<Void>()
        switch(self.powerUpData.index.integerValue) {
            
        case 0://Antigravidade
            self.eventBegin?.addHandler({
                player.physicsBody!.affectedByGravity = false
            })
            self.eventEnd?.addHandler({
                player.physicsBody!.affectedByGravity = true
            })
            break
            
        case 1://Invencibilidade
            self.eventBegin?.addHandler({
                player.physicsBody!.contactTestBitMask =
                    physicsCategory.winTile.rawValue |
                    physicsCategory.coin.rawValue |
                    physicsCategory.doorTile.rawValue
            })
            self.eventEnd?.addHandler({
                player.resetCategoryBitMasks()
            })
            
            break
        default:
            self.eventBegin = nil
            self.eventUpdate = nil
            self.eventEnd = nil
            break
        }
    }
    
    class func doLogic(currentTime: NSTimeInterval) {
        for powerUp in PowerUp.powerUpList {
            if powerUp.pressed == true {
                if currentTime - powerUp.lastUse > powerUp.powerUpType.coolDown {
                    
                    let playerData = MemoryCard.sharedInstance.playerData
                    if(powerUp.powerUpType.price <= Int(playerData.coins)) {
                        playerData.coins = NSNumber(integer: Int(playerData.coins) - powerUp.powerUpType.price)
                        if let scene = powerUp.scene as? MissionScene {
                            scene.labelCoins.setText(String(Int(MemoryCard.sharedInstance.playerData.coins) + scene.collectedBonus))
                        }
                        if let scene = powerUp.scene as? MultiplayerGameScene {
                            scene.labelCoins.setText(String(Int(MemoryCard.sharedInstance.playerData.coins) + scene.collectedBonus))
                        }
                        powerUp.eventBegin?.raise()
                        powerUp.lastUse = currentTime
                        powerUp.inUse = true
                        powerUp.needUpdate = true
                    }
                }
            }
            
            if (powerUp.inUse == true) {
                if(powerUp.needUpdate == true) {
                    powerUp.eventUpdate?.raise()
                    if currentTime - powerUp.lastUse > powerUp.powerUpType.duration {
                        powerUp.eventEnd?.raise()
                        powerUp.needUpdate = false
                    }
                }
                
                if currentTime - powerUp.lastUse > powerUp.powerUpType.coolDown {
                    powerUp.inUse = false
                }
            }
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
    var duration:NSTimeInterval
    var price:Int
    
    init(powerUpImage:String, price:Int, coolDown:NSTimeInterval, duration:NSTimeInterval) {
        self.powerUpImage = powerUpImage
        self.coolDown = coolDown
        self.duration = duration
        self.price = price
    }
}

class PowerUps :NSObject {
    static var types = Array<PowerUpType>([
        PowerUpType(powerUpImage:"powerUp A", price:100, coolDown:10, duration:5),
        PowerUpType(powerUpImage:"powerUp B", price:200, coolDown:10, duration:10)
        ])
}
