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
    
    var skinsScrollNode:ScrollNode!
    
    var mySkins = NSMutableArray()//SkinsDesbloqueadas/Conpradas
    
    var boxCoins:Control!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        self.addChild(Button(name: "buttonPowerUp0", textureName: "buttonBlueSquare", text:"1", x: 497, y: 630, xAlign:.center, yAlign:.down))
        self.addChild(Button(name: "buttonPowerUp1", textureName: "buttonOrangeSquare", text:"2", x: 617, y: 630, xAlign:.center, yAlign:.down))
        self.addChild(Button(name: "buttonPowerUp2", textureName: "buttonYellowSquare", text:"3", x: 737, y: 630, xAlign:.center, yAlign:.down))
        
        self.addChild(Button(name: "buttonPlay", textureName: "buttonYellow", text:"GO!", x: 1014, y: 630, xAlign:.right, yAlign:.down))
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down))
        
        self.boxCoins = Control(name: "boxCoins", textureName: "boxCoins", x: 1058, y: 20, xAlign: .right, yAlign: .up)
        self.boxCoins.addChild(Label(name: "lebelCoins", color: GameColors.black, textureName: self.playerData.coins.description, x: 160, y: 39))
        self.addChild(self.boxCoins)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState){
            switch (self.state) {
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.mission:
                self.view!.presentScene(MissionScene(), transition: Config.defaultGoTransition)
                break
                
            case states.chooseSkin:
                self.player.removeFromParent()
                
                var skinsArray = Array<SKSpriteNode>()
                
                //Skins desbloqueadas
                for skin in self.playerData.skins as! Set<SkinData> {
                    self.mySkins.addObject(skin.index.description)//Gravando indices das minhas skins
                    
                    let cell = SKSpriteNode(imageNamed: "boxSmall")
                    cell.name = String(skin.index.description)
                    
                    let skinType = Skins.types[Int(skin.index)]
                    
                    cell.addChild(SKSpriteNode(imageNamed: skinType.imageName))
                    
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
                        
                        var spriteNodeSkin = SKSpriteNode(imageNamed: skinType.imageName)
                        spriteNodeSkin.color = GameColors.black
                        spriteNodeSkin.colorBlendFactor = 0.8
                        cell.addChild(spriteNodeSkin)
                        spriteNodeSkin.zPosition = 1
                        
                        var spriteNodeBox = SKSpriteNode(imageNamed: "boxSmallLocked")
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
                
                var spriteNodeBox = SKSpriteNode(imageNamed: "boxSmallLocked")
                cell.addChild(spriteNodeBox)
                
                cell.addChild(Label(name: "lebel", color:GameColors.white, textureName: "?", x: 0, y: 0))
                
                skinsArray.append(cell)
                //
                
                self.skinsScrollNode = ScrollNode(name: "skins", x: 667, y: 466, align: .center, cells: skinsArray, spacing: 0, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: true, scaleDistance:1334/4 + 100)
                self.addChild(skinsScrollNode)
                
                break
                
            case states.beforeMission:
                self.player = Player(playerData: self.playerData, x: 603, y: 342, loadPhysics: false)
                self.addChild(self.player)
                
                if let teste = self.skinsScrollNode {
                    teste.removeFromParent()
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
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.beforeMission:
                for touch in (touches as! Set<UITouch>) {
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
                }
                break
            case states.chooseSkin:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonPlay")!.containsPoint(location)) {
                        self.nextState = .mission
                        return
                    }
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .floors
                        return
                    }
                    
                    if(touch.tapCount > 0) {
                        if (self.skinsScrollNode.containsPoint(location)) {
                            let locationInScrollNode = touch.locationInNode(self.skinsScrollNode)
                            
                            for cell in self.skinsScrollNode.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    if(!self.mySkins.containsObject(cell.name!)) {
                                        let cellIndex:Int = cell.name!.toInt()!
                                        if(cellIndex >= Skins.types.count) {
                                            return
                                        }
                                        let skinType = Skins.types[cellIndex]
                                        if(Int(self.playerData.coins) >= skinType.price) {
                                            let skinData = MemoryCard.sharedInstance.newSkinData()
                                            skinData.index = NSNumber(integer: cell.name!.toInt()!)
                                            self.playerData.addSkin(skinData)
                                            self.playerData.currentSkin = skinData
                                            self.playerData.coins = NSNumber(integer: Int(self.playerData.coins) - skinType.price)
                                            (self.boxCoins.childNodeWithName("lebelCoins") as! Label).setText(self.playerData.coins.description)
                                            self.nextState = states.beforeMission
                                        } else {
                                            //TODO: assistir video para ganhar mais moedas???
                                            println("Não tenho dinheiro para comprar")
                                        }
                                    } else {
                                        for skin in self.playerData.skins as! Set<SkinData> {
                                            if (skin.index.description == cell.name!) {
                                                self.playerData.currentSkin = skin
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
                
            default:
                break
            }
        }
    }
}
