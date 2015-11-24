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
        case powerUpsInfo
        //case chooseSkin
        //case choosePowerUps
        case floors
    }
    
    var state = states.loading
    var nextState = states.beforeMission
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var boxCoins:BoxCoins!
    
    var player:Player!
    var powerUpSlotsScrollNode:ScrollNode!
    
    var skinsScrollNode:ScrollNode!
    var powerUpsScrollNode:ScrollNode!
    var powerUpsInfoScrollNode:ScrollNode!
    
    var mySkins = NSMutableArray()//Skins Desbloqueadas/Compradas
    //var myPowerUps = NSMutableArray()//PowerUps Desbloqueados/Comprados
    
    var buttonPlay:Button!
    var buttonBack:Button!
    var buttonPowerUpsInfo:Button!
    
    var boxPowerUpsInfo:CropBox!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(textureName: "background", x:-49, y:-32, xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        //PowerUps
        if(self.playerData.powerUps.count > 0) {
            var powerUpSlotsArray = Array<SKNode>()
            
            for item in self.playerData.powerUpSlots {
                powerUpSlotsArray.append(PowerUpSlot(powerUpSlotData: item as! PowerUpSlotData))
            }
            
            self.powerUpSlotsScrollNode = ScrollNode(x: 547, y: 680, xAlign: .center, yAlign: .down, cells: powerUpSlotsArray, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: false)
            self.powerUpSlotsScrollNode.canScroll = false
            self.addChild(self.powerUpSlotsScrollNode)
        }
        //
        
        self.buttonPlay = Button(textureName: "buttonPink", text:"GO!", x: 1014, y: 630, xAlign:.right, yAlign:.down, fontColor:.white)
        self.addChild(self.buttonPlay)
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        self.boxCoins = BoxCoins()
        self.addChild(boxCoins)
        
        self.showSkins()
        self.showPowerUps()
    }
    
    func showPowerUps() {
        if let teste = self.powerUpsScrollNode {
            teste.removeFromParent()
        }
        if let teste = self.powerUpsInfoScrollNode {
            teste.removeFromParent()
        }
        
        var powerUpsArray = Array<PowerUp>()
        
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
        //                let cell = SKSpriteNode(imageNamed: "powerUpSlot")
        //                cell.name = "-1"
        //
        //                let spriteNode = SKSpriteNode(imageNamed: "powerUpSlot")
        //                spriteNode.color = GameColors.black
        //                spriteNode.colorBlendFactor = 1
        //                cell.addChild(spriteNode)
        //
        //                cell.addChild(Label(name: "lebelName", color:GameColors.white, textureName: "?", x: 0, y: 0))
        //                //
        //
        //                powerUpsArray.append(cell)
        
        self.powerUpsScrollNode = ScrollNode(x: 667, y: 566, cells: powerUpsArray, scrollDirection: .horizontal, scaleNodes: true, scaleDistance:1334 + 100, index:Int(powerUpsArray.count/2))
        self.addChild(self.powerUpsScrollNode)
        ScrollNode.scrollNodeList.remove(self.powerUpsScrollNode)//TODO: remover esta linha para scrollar powerUps
        
        self.buttonPowerUpsInfo = Button(textureName: "buttonBlueSquare", icon: "about_filled", x: 297, y: 630, xAlign: .center, yAlign: .down, top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonPowerUpsInfo)
        
        self.boxPowerUpsInfo = CropBox(textureName: "box1024x512", xAlign:.center, yAlign:.center)
        self.addChild(self.boxPowerUpsInfo)
        
        powerUpsArray = Array<PowerUp>()
        
        //PowerUps desbloqueados
        for item in self.playerData.powerUps {
            let powerUp = PowerUp(powerUpData: item as! PowerUpData)
            powerUp.addChild(Label(text: powerUp.powerUpType.text, x:100, y:0, horizontalAlignmentMode:SKLabelHorizontalAlignmentMode.Left))
            powerUpsArray.append(powerUp)
        }
        
        self.powerUpsInfoScrollNode = ScrollNode(x: 100, y: 100, cells: powerUpsArray, scrollDirection: .vertical, scaleNodes: false, scaleDistance:1334 + 100)
        self.boxPowerUpsInfo.addChild(self.powerUpsInfoScrollNode)
        
        self.boxPowerUpsInfo.zPosition = self.skinsScrollNode.zPosition + 10000
        self.boxPowerUpsInfo.hidden = true
    }
    
    func showSkins() {
        
        if let teste = self.skinsScrollNode {
            teste.removeFromParent()
        }
        
        var skinsArray = Array<SKNode>()
        self.mySkins = NSMutableArray()
        
        var i = 0
        var index = 0
        
        //Skins desbloqueadas
        for item in self.playerData.skins as NSOrderedSet {
            
            let skin = item as! SkinData
            
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
            if(self.playerData.skinSlot.skin == skin) {
                index = i
            }
            i++
        }
        
        //Skins bloqueadas
        var skinIndex = 0
        for skinType in Skins.types {
            if(!self.mySkins.containsObject(skinIndex.description)) {
                let cell = SKSpriteNode(imageNamed: "boxSmall")
                cell.name = skinIndex.description
                
                let spriteNodeSkin = SKSpriteNode(imageNamed: skinType.imageName)
                spriteNodeSkin.color = GameColors.black
                
                cell.addChild(spriteNodeSkin)
                spriteNodeSkin.zPosition = 1
                
                let spriteNodeBox = SKSpriteNode(imageNamed: "boxSmallLocked")
                cell.addChild(spriteNodeBox)
                spriteNodeBox.zPosition = 2
                
                
                var spriteNodeIcon:SKSpriteNode!
                if (skinType.buyWithCoins == true) {
                    spriteNodeIcon = SKSpriteNode(imageNamed: "hudCoin")
                    spriteNodeSkin.colorBlendFactor = 0.9
                } else {
                    spriteNodeIcon = SKSpriteNode(imageNamed: "hudJewel_blue")
                    spriteNodeSkin.colorBlendFactor = 0.5
                }
                
                spriteNodeIcon.position = CGPoint(x: -32, y: -32)
                cell.addChild(spriteNodeIcon)
                spriteNodeIcon.zPosition = 3
                
                cell.addChild(Label(color:GameColors.white, text: "?", x: 0, y: 0))
                
                cell.addChild(Label(color:GameColors.white, text: skinType.price.description, x: 64, y: 64))
                
                skinsArray.append(cell)
            }
            skinIndex++
        }
        
        //Skin misteriosa =}
        let cell = SKSpriteNode(imageNamed: "boxSmall")
        cell.name = skinIndex.description
        
        let spriteNodeBox = SKSpriteNode(imageNamed: "boxSmallLocked")
        cell.addChild(spriteNodeBox)
        
        cell.addChild(Label(color:GameColors.white, text: "?"))
        
        skinsArray.append(cell)
        //
        
        self.skinsScrollNode = ScrollNode(x: 667, y: 366, cells: skinsArray, spacing: 0, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: true, scaleDistance:1334/4 + 100, index:index)
        self.addChild(skinsScrollNode)
        
        let top:Int = 0
        let bottom:Int = 0
        let left:Int = 300
        let right:Int = 300
        
        let texture = SKTexture(imageNamed: "boxSmall")
        
        let spriteNode = SKSpriteNode(texture: nil, color: UIColor.clearColor(),
            size: CGSize(width: Int(texture.size().width) + left + right, height: Int(texture.size().height) + top + bottom))
        
        self.skinsScrollNode.addChild(spriteNode)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        if(self.state == self.nextState) {
            switch (self.state) {
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.mission:
                self.view!.presentScene(MissionScene(), transition: Config.defaultTransition)
                break
                
            case states.beforeMission:
                self.blackSpriteNode.hidden = true
                self.boxPowerUpsInfo.hidden = true
                self.player = Player(playerData: self.playerData, x: 667, y: 466, loadPhysics: false)
                self.player.hidden = true
                self.addChild(self.player)
                
                break
                
            case states.powerUpsInfo:
                self.boxPowerUpsInfo.hidden = false
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = self.boxPowerUpsInfo.zPosition - 1
                self.buttonBack.zPosition = self.blackSpriteNode.zPosition + 1
                break
                
            case states.floors:
                self.view!.presentScene(FloorsScene(), transition: Config.defaultTransition)
                break
                
            default:
                break
            }
        }
    }
    
    func touchesEndedPowerUps(touch:UITouch, location:CGPoint) {
        if(touch.tapCount > 0) {
            if (self.powerUpSlotsScrollNode.containsPoint(location)) {
                let locationInScrollNode = touch.locationInNode(self.powerUpSlotsScrollNode)
                
                for powerUpSlot in self.powerUpSlotsScrollNode.cells {
                    if(powerUpSlot.containsPoint(locationInScrollNode)) {
                        if let powerUpSlot = powerUpSlot as? PowerUpSlot {
                            for powerUp in self.powerUpsScrollNode.cells {
                                if let powerUp = powerUp as? PowerUp {
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
            }
        }
    }
    
    func touchesEndedSkins(touch:UITouch, location:CGPoint) {
        if(touch.tapCount > 0) {
            if (self.skinsScrollNode.containsPoint(location)) {
                let locationInScrollNode = touch.locationInNode(self.skinsScrollNode)
                
                for skin in self.skinsScrollNode.cells {
                    if(skin.containsPoint(locationInScrollNode)) {
                        if(!self.mySkins.containsObject(skin.name!)) {
                            let cellIndex:Int = Int(skin.name!)!
                            if(cellIndex >= Skins.types.count) {
                                return
                            }
                            let skinType = Skins.types[cellIndex]
                            
                            if (skinType.buyWithCoins == true) {
                                if(Int(self.playerData.coins) >= skinType.price) {
                                    let skinData = MemoryCard.sharedInstance.newSkinData()
                                    skinData.index = NSNumber(integer: Int(skin.name!)!)
                                    self.playerData.addSkin(skinData)
                                    self.playerData.skinSlot.skin = skinData
                                    self.playerData.coins = NSNumber(integer: Int(self.playerData.coins) - skinType.price)
                                    self.boxCoins.labelCoins.setText(self.playerData.coins.description)
                                    self.showSkins()
                                } else {
                                    //TODO: assistir video para ganhar mais moedas???
                                    print("Não tenho dinheiro para comprar")
                                }
                            } else {
                                //Tentando comprar com gemas
                                if(Int(self.playerData.gems) >= skinType.price) {
                                    let skinData = MemoryCard.sharedInstance.newSkinData()
                                    skinData.index = NSNumber(integer: Int(skin.name!)!)
                                    self.playerData.addSkin(skinData)
                                    self.playerData.skinSlot.skin = skinData
                                    self.playerData.gems = NSNumber(integer: Int(self.playerData.gems) - skinType.price)
                                    self.boxCoins.labelGems.setText(self.playerData.gems.description)
                                    self.showSkins()
                                } else {
                                    //TODO: assistir video para ganhar mais gemas???
                                    print("Não tenho gemas para comprar")
                                }
                            }
                        } else {
                            for item in self.playerData.skins {
                                let skinData = item as! SkinData
                                if (skinData.index.description == skin.name!) {
                                    self.playerData.skinSlot.skin = skinData
                                    self.showSkins()
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.beforeMission:
                for touch in touches {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonPlay.containsPoint(location)) {
                        self.nextState = .mission
                        return
                    }
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .floors
                        return
                    }
                    
                    if(self.boxCoins.containsPoint(location)) {
                        self.boxCoins.containsPoint()
                    }
                    
                    if(self.buttonPowerUpsInfo.containsPoint(location)) {
                        self.nextState = .powerUpsInfo
                    }
                    
                    self.touchesEndedSkins(touch, location: location)
                    
                    self.touchesEndedPowerUps(touch, location: location)
                    
                }
                break
                
            case states.powerUpsInfo:
                for touch in touches {
                    let location = touch.locationInNode(self)
                    
                    if !(self.boxPowerUpsInfo.cropNode.containsPoint(location)) {
                        self.nextState = .beforeMission
                        return
                    }
                }
                break
                
            default:
                break
            }
        }
    }
}
