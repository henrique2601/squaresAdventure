//
//  BeforeMissionScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class BeforeMissionScene: GameScene {
    enum states {
        case loading
        case beforeMission
        case mission
        case chooseSkin
        case choosePowerUps
        case floors
    }
    
    var state = states.loading
    var nextState = states.beforeMission
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var player:Player!
    var powerUpSlotsScrollNode:ScrollNode!
    
    var skinsScrollNode:ScrollNode!
    var powerUpsScrollNode:ScrollNode!
    
    var mySkins = NSMutableArray()//Skins Desbloqueadas/Compradas
    //var myPowerUps = NSMutableArray()//PowerUps Desbloqueados/Comprados
    
    var boxCoins:Control!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        //PowerUps
        if(self.playerData.powerUps.count > 0) {
            var powerUpSlotsArray = Array<SKNode>()
            
            for item in self.playerData.powerUpSlots {
                powerUpSlotsArray.append(PowerUpSlot(powerUpSlotData: item as! PowerUpSlotData))
            }
            
            self.powerUpSlotsScrollNode = ScrollNode(name: "powerUpSlotsScrollNode", textureName: "", x: 667, y: 680, xAlign: .center, yAlign: .down, cells: powerUpSlotsArray, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: false)
            self.powerUpSlotsScrollNode.canScroll = false
            self.addChild(self.powerUpSlotsScrollNode)
            var position = self.powerUpSlotsScrollNode.position
        }
        //
        
        self.addChild(Button(name: "buttonPlay", textureName: "buttonYellow", text:"GO!", x: 1014, y: 630, xAlign:.right, yAlign:.down))
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down))
        
        self.boxCoins = Control(name: "boxCoins", textureName: "boxCoins", x: 1058, y: 20, xAlign: .right, yAlign: .up)
        self.boxCoins.addChild(Label(name: "lebelCoins", color: GameColors.black, textureName: self.playerData.coins.description, x: 160, y: 39))
        self.addChild(self.boxCoins)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState) {
            switch (self.state) {
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.mission:
                self.view!.presentScene(MissionScene(), transition: Config.defaultGoTransition)
                break
                
            case states.chooseSkin:
                self.player.removeFromParent()
                
                var skinsArray = Array<SKNode>()
                self.mySkins = NSMutableArray()
                
                //Skins desbloqueadas
                for skin in self.playerData.skins as! Set<SkinData> {
                    self.mySkins.addObject(skin.index.description)//Gravando indices das minhas skins
                    
                    let cell = SKSpriteNode(imageNamed: "boxSmall")
                    cell.name = String(skin.index.description)
                    
                    let skinType = Skins.types[skin.index.integerValue]
                    
                    let spriteNodeSkin = SKSpriteNode(imageNamed: skinType.imageName)
                    spriteNodeSkin.zPosition = cell.zPosition + 1
                    cell.addChild(spriteNodeSkin)
                    
                    //cell.addChild(Label(name: "lebelName", color:GameColors.black, textureName: "", x: 0, y: -100))
                    
                    //cell.addChild(Label(name: "lebelPrice", color:GameColors.black, textureName: skinType.price.description, x: 0, y: 100))
                    
                    skinsArray.append(cell)
                }
                
                //Skins bloqueadas
                var skinIndex = 0
                for skinType in Skins.types {
                    if(!self.mySkins.containsObject(skinIndex.description)) {
                        let cell = SKSpriteNode(imageNamed: "boxSmall")
                        cell.name = skinIndex.description
                        
                        let spriteNodeSkin = SKSpriteNode(imageNamed: skinType.imageName)
                        spriteNodeSkin.color = GameColors.black
                        spriteNodeSkin.colorBlendFactor = 1
                        cell.addChild(spriteNodeSkin)
                        spriteNodeSkin.zPosition = 1
                        
                        let spriteNodeBox = SKSpriteNode(imageNamed: "boxSmallLocked")
                        cell.addChild(spriteNodeBox)
                        spriteNodeBox.zPosition = 2
                        
                        cell.addChild(Label(name: "lebelName", color:GameColors.white, textureName: "?", x: 0, y: 0))
                        
                        cell.addChild(Label(name: "lebelPrice", color:GameColors.white, textureName: skinType.price.description, x: 0, y: 100))
                        
                        skinsArray.append(cell)
                    }
                    skinIndex++
                }
                
                //Skin misteriosa =}
                let cell = SKSpriteNode(imageNamed: "boxSmall")
                cell.name = skinIndex.description
                
                let spriteNodeBox = SKSpriteNode(imageNamed: "boxSmallLocked")
                cell.addChild(spriteNodeBox)
                
                cell.addChild(Label(name: "lebel", color:GameColors.white, textureName: "?", x: 0, y: 0))
                
                skinsArray.append(cell)
                //
                
                self.skinsScrollNode = ScrollNode(name: "skins", x: 667, y: 466, align: .center, cells: skinsArray, spacing: 0, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: true, scaleDistance:1334/4 + 100)
                self.addChild(skinsScrollNode)
                
                break

                
            case states.choosePowerUps:
                self.player.removeFromParent()
                
                var powerUpsArray = Array<SKNode>()
                    
                //PowerUps desbloqueados
                for item in self.playerData.powerUps {
                    let powerUp = PowerUp(powerUpData: item as! PowerUpData)
                    for item in self.powerUpSlotsScrollNode.cells {
                        if let powerUpSlot = item as? PowerUpSlot {
                            if powerUpSlot.powerUpSlotData.powerUp?.index == powerUp.powerUpData.index {
                                powerUp.inUse = true
                                break
                            }
                        }
                    }
                    powerUpsArray.append(powerUp)
                }
                
                // PowerUp "?"
                let cell = SKSpriteNode(imageNamed: "powerUpSlot")
                cell.name = "-1"
                
                let spriteNode = SKSpriteNode(imageNamed: "powerUpSlot")
                spriteNode.color = GameColors.black
                spriteNode.colorBlendFactor = 1
                cell.addChild(spriteNode)
                
                cell.addChild(Label(name: "lebelName", color:GameColors.white, textureName: "?", x: 0, y: 0))
                //
                
                powerUpsArray.append(cell)
                
                self.powerUpsScrollNode = ScrollNode(name: "powerUpsScrollNode", x: 667, y: 466, align: .center, cells: powerUpsArray, scrollDirection: .horizontal, scaleNodes: true, scaleDistance:1334 + 100)
                self.addChild(self.powerUpsScrollNode)
                
                break
                
            case states.beforeMission:
                self.player = Player(playerData: self.playerData, x: 667, y: 466, loadPhysics: false)
                self.addChild(self.player)
                
                if let teste = self.skinsScrollNode {
                    teste.removeFromParent()
                }
                if let teste = self.powerUpsScrollNode {
                    powerUpsScrollNode.removeFromParent()
                }
                break
                
            case states.floors:
                self.view!.presentScene(FloorsScene(), transition: Config.defaultBackTransition)
                break
                
            default:
                break
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if (self.state == self.nextState) {
            switch (self.state) {
//            case states.choosePowerUps:
//                for touch in (touches as! Set<UITouch>) {
//                    let location = touch.locationInNode(self)
//                    if (self.powerUpsScrollNode.containsPoint(location)) {
//                        let locationInScrollNode = touch.locationInNode(self.powerUpsScrollNode)
//                        
//                        for cell in self.powerUpsScrollNode.cells {
//                            if(cell.containsPoint(locationInScrollNode)) {
//                                println("Iniciou toque em PowerUp " + cell.name!)
//                                
//                                return
//                            }
//                        }
//                    }
//                }
//                break
                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.beforeMission:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonPlay")!.containsPoint(location)) {
                        self.nextState = .mission
                        return
                    }
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .floors
                        return
                    }
                    
                    if (self.player.containsPoint(location)) {
                        self.nextState = .chooseSkin
                        return
                    }
                    
                    if(self.playerData.powerUps.count > 0) {
                        if(self.powerUpSlotsScrollNode.containsPoint(location)) {
                            self.nextState = .choosePowerUps
                            return
                        }
                    }
                }
                break
            case states.chooseSkin:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonPlay")!.containsPoint(location)) {
                        self.nextState = .mission
                        return
                    }
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .beforeMission
                        return
                    }
                    
                    if(touch.tapCount > 0) {
                        if (self.skinsScrollNode.containsPoint(location)) {
                            let locationInScrollNode = touch.locationInNode(self.skinsScrollNode)
                            
                            for cell in self.skinsScrollNode.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    if(!self.mySkins.containsObject(cell.name!)) {
                                        let cellIndex:Int = Int(cell.name!)!
                                        if(cellIndex >= Skins.types.count) {
                                            return
                                        }
                                        let skinType = Skins.types[cellIndex]
                                        if(Int(self.playerData.coins) >= skinType.price) {
                                            let skinData = MemoryCard.sharedInstance.newSkinData()
                                            skinData.index = NSNumber(integer: Int(cell.name!)!)
                                            self.playerData.addSkin(skinData)
                                            self.playerData.skinSlot.skin = skinData
                                            self.playerData.coins = NSNumber(integer: Int(self.playerData.coins) - skinType.price)
                                            (self.boxCoins.childNodeWithName("lebelCoins") as! Label).setText(self.playerData.coins.description)
                                            self.nextState = states.beforeMission
                                        } else {
                                            //TODO: assistir video para ganhar mais moedas???
                                            print("Não tenho dinheiro para comprar")
                                        }
                                    } else {
                                        for skin in self.playerData.skins as! Set<SkinData> {
                                            if (skin.index.description == cell.name!) {
                                                self.playerData.skinSlot.skin = skin
                                                self.nextState = states.beforeMission
                                                return
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            self.nextState = states.beforeMission
                        }
                    }
                }
                break
                
            case states.choosePowerUps:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonPlay")!.containsPoint(location)) {
                        self.nextState = .mission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .beforeMission
                        return
                    }
                    
                    if(touch.tapCount > 0) {
                        if (self.powerUpSlotsScrollNode.containsPoint(location)) {
                            let locationInScrollNode = touch.locationInNode(self.powerUpSlotsScrollNode)
                            
                            for cell in self.powerUpSlotsScrollNode.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    if let powerUpSlot = cell as? PowerUpSlot {
                                        for item in self.powerUpsScrollNode.cells {
                                            if let powerUp = item as? PowerUp {
                                                if (powerUp.powerUpData.index == powerUpSlot.powerUpSlotData.powerUp?.index) {
                                                    powerUp.inUse = false
                                                    break
                                                }
                                            }
                                        }
                                        powerUpSlot.reset()
                                    }
                                }
                            }
                            return
                        }
                        
                        if (self.powerUpsScrollNode.containsPoint(location)) {
                            let locationInScrollNode = touch.locationInNode(self.powerUpsScrollNode)
                            
                            for cell in self.powerUpsScrollNode.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    
                                    for powerUpSlot in self.powerUpSlotsScrollNode.cells as! Array<PowerUpSlot> {
                                        if(powerUpSlot.empty) {
                                            if let powerUp = cell as? PowerUp {
                                                if(!powerUp.inUse) {
                                                    powerUp.inUse = true
                                                    powerUpSlot.setPowerUp(powerUp.powerUpData)
                                                }
                                            }
                                            break
                                        }
                                    }
                                    return
                                }
                            }
                        } else {
                            self.nextState = states.beforeMission
                            return
                        }
                    }
                }
                break
                
            default:
                break
            }
        }
    }
}
