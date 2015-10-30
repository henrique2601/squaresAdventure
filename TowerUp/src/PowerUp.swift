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
    
    var labelPrice:Label!
    var labelPricePressed:Label!
    
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
    
    init(powerUpData:PowerUpData, colorBlendFactor:CGFloat = 1) {
        self.powerUpData = powerUpData
        super.init()
        self.load(colorBlendFactor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(colorBlendFactor:CGFloat) {
        let name:String = powerUpData.index.description
        self.name = name
        
        self.powerUpType = PowerUps.types[powerUpData.index.integerValue]
        
        let texture = SKTexture(imageNamed: self.powerUpType.powerUpImage)
        self.powerUp = SKSpriteNode(texture: texture, size: texture.size())
        self.powerUp.color = UIColor(red: 1, green: 1, blue: 1, alpha: colorBlendFactor)
        self.powerUp.colorBlendFactor = 1
        self.powerUpShadow = SKSpriteNode(texture: texture, size: texture.size())
        self.powerUpShadow.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75 * colorBlendFactor)
        self.powerUpShadow.colorBlendFactor = 1
        self.powerUpShadow.hidden = true
        
        self.labelPrice = Label(text: self.powerUpType.price.description, x: 0, y: 31)
        self.powerUp.addChild(self.labelPrice)
        self.addChild(self.powerUp)
        self.powerUp.addChild(self.powerUpShadow)
        
        let texturePressed = SKTexture(imageNamed: "\(self.powerUpType.powerUpImage)Pressed")
        self.powerUpPressed = SKSpriteNode(texture: texturePressed, size: texturePressed.size())
        self.powerUpPressed.color = UIColor(red: 1, green: 1, blue: 1, alpha: colorBlendFactor)
        self.powerUpPressed.colorBlendFactor = 1
        self.powerUpPressedShadow = SKSpriteNode(texture: texturePressed, size: texturePressed.size())
        self.powerUpPressedShadow.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75 * colorBlendFactor)
        self.powerUpPressedShadow.colorBlendFactor = 1
        self.powerUpPressedShadow.hidden = true
        
        self.labelPricePressed = Label(text: self.powerUpType.price.description, x: 0, y: 31 + 2)
        self.powerUpPressed.addChild(self.labelPricePressed)
        self.powerUpPressed.hidden = true
        self.addChild(self.powerUpPressed)
        self.powerUpPressed.addChild(self.powerUpPressedShadow)
        
        PowerUp.powerUpList.insert(self)
    }
    
    func loadEvent(player:Player, world:World) {
        
        self.eventBegin = Event<Void>()
        self.eventUpdate = Event<Void>()
        self.eventEnd = Event<Void>()
        switch(self.powerUpData.index.integerValue) {
            
        case 0://Antigravidade
            
            var emitterNode:SKEmitterNode!
            
            self.eventBegin?.addHandler({
                //
                emitterNode = SKEmitterNode(fileNamed: "PowerUp0.sks")!
                emitterNode.targetNode = player.parent!
                player.parent!.addChild(emitterNode)
                //
                
                if(player.healthPoints > 0) {
                    world.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.98)
                } else {
                    self.lastUse = -1
                }
            })
            self.eventUpdate?.addHandler({
                emitterNode.position = player.position
            })
            self.eventEnd?.addHandler({
                world.physicsWorld.gravity = world.defaultGravity
                emitterNode.particleAlpha = 0
                emitterNode.particleAlphaRange = 0
                emitterNode.runAction(SKAction.fadeOutWithDuration(1), completion: {
                    emitterNode.removeFromParent()
                })
                
            })
            break
            
        case 1://Invencibilidade
            var emitterNode:SKEmitterNode!
            
            self.eventBegin?.addHandler({
                
                if(player.healthPoints > 0) {
                    //
                    emitterNode = SKEmitterNode(fileNamed: "PowerUp1_2.sks")!
                    emitterNode.targetNode = player.parent!
                    player.parent!.addChild(emitterNode)
                    //
                } else {
                    self.lastUse = -1
                }
            })
            self.eventUpdate?.addHandler({
                emitterNode.position = player.position
                player.healthPoints = player.maxHealthPoints
            })
            
            self.eventEnd?.addHandler({
                emitterNode.particleAlpha = 0
                emitterNode.particleAlphaRange = 0
                emitterNode.runAction(SKAction.fadeOutWithDuration(1), completion: {
                    emitterNode.removeFromParent()
                })
            })
            break
            
        case 2://Fenix Caida :D
            var emitterNode:SKEmitterNode!
            
            self.eventBegin?.addHandler({
                
                if(player.healthPoints <= 0) {
                    
                    emitterNode = SKEmitterNode(fileNamed: "PlayerSpawn.sks")!
                    player.parent?.addChild(emitterNode)
                    emitterNode.zPosition = player.zPosition + 1
                    emitterNode.position = player.position
                    
                    player.healthPoints = player.maxHealthPoints
                    player.needToPlayDeathAnimation = true
                } else {
                    self.lastUse = -1
                }
            })
            break
            
        case 3://Reverse Gravity
            self.eventBegin?.addHandler({
                if(player.healthPoints > 0) {
                    world.physicsWorld.gravity = CGVector(dx: 0.0, dy: 9.8)
                } else {
                    self.lastUse = -1
                }
            })
            self.eventEnd?.addHandler({
                world.physicsWorld.gravity = world.defaultGravity
            })
            break
            
        case 4://Bomba Caixa! :D
            var bomb:BoxExplosive!
            
            self.eventBegin?.addHandler({
                if(player.healthPoints > 0) {
                    bomb = BoxExplosive(position: player.position)
                    player.parent?.addChild(bomb)
                     if let scene = player.scene as? MultiplayerMissionScene {
                        print(scene.room.description + "room")
                        scene.socket.emit("crateBomb", scene.room ,Int(player.position.x) , Int(player.position.y) )
                    }
                } else {
                    self.lastUse = -1
                }
            })
            self.eventEnd?.addHandler({
                bomb.activate()
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
                        powerUp.lastUse = currentTime
                        powerUp.eventBegin?.raise()
                        if(powerUp.lastUse != -1) {// -1 significa que o PowerUp não pode ser ativado.
                            playerData.coins = NSNumber(integer: Int(playerData.coins) - powerUp.powerUpType.price)
                            if let scene = powerUp.scene as? MissionScene {
                                scene.boxCoins.labelCoins.setText(MemoryCard.sharedInstance.playerData.coins.description)
                            }
                            if let scene = powerUp.scene as? MultiplayerMissionScene {
                                scene.boxCoins.labelCoins.setText(MemoryCard.sharedInstance.playerData.coins.description)
                            }
                            PowerUp.updatePowerUpLabels()
                            powerUp.inUse = true
                            powerUp.needUpdate = true
                        }
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
    
    class func updatePowerUpLabels() {
        let playerData = MemoryCard.sharedInstance.playerData
        for powerUp in PowerUp.powerUpList {
            if(powerUp.powerUpType.price <= Int(playerData.coins)) {
                powerUp.labelPrice.setText(powerUp.powerUpType.price.description, color: GameColors.black)
                powerUp.labelPricePressed.setText(powerUp.powerUpType.price.description, color: GameColors.black)
            } else {
                powerUp.labelPrice.setText(powerUp.powerUpType.price.description, color: GameColors.red)
                powerUp.labelPricePressed.setText(powerUp.powerUpType.price.description, color: GameColors.red)
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
        PowerUpType(powerUpImage:"powerUp A", price:50, coolDown:5, duration:3),
        PowerUpType(powerUpImage:"powerUp B", price:75, coolDown:10, duration:5),
        PowerUpType(powerUpImage:"powerUp C", price:150, coolDown:10, duration:0),
        PowerUpType(powerUpImage:"powerUp D", price:500, coolDown:30, duration:2),
        PowerUpType(powerUpImage:"powerUp E", price:50, coolDown:3, duration:1)
        ])
}
