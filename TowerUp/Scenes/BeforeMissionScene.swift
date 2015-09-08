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
        case beforeMission
        case mission
        case chooseSkin
        case choosePowerUps
        case floors
    }
    
    var state = states.beforeMission
    var nextState = states.beforeMission
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var player:Player!
    
    var skinsScrollNode:ScrollNode!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        self.player = Player(playerData: self.playerData, x: 603, y: 342, loadPhysics: false)
        self.addChild(self.player)
        
        self.addChild(Button(name: "buttonPowerUp0", textureName: "buttonBlueSquare", text:"1", x: 497, y: 630, xAlign:.center, yAlign:.down))
        self.addChild(Button(name: "buttonPowerUp1", textureName: "buttonOrangeSquare", text:"2", x: 617, y: 630, xAlign:.center, yAlign:.down))
        self.addChild(Button(name: "buttonPowerUp2", textureName: "buttonYellowSquare", text:"3", x: 737, y: 630, xAlign:.center, yAlign:.down))
        
        self.addChild(Button(name: "buttonPlay", textureName: "buttonYellow", text:"GO!", x: 1014, y: 630, xAlign:.right, yAlign:.down))
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down))
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
                self.player.hidden = true
                
                var skinsArray = Array<SKSpriteNode>()
                var mySkins = NSMutableArray()
                
                //Skins desbloqueadas
                for skin in self.playerData.skins as! Set<SkinData> {
                    mySkins.addObject(Int(skin.index))//Gravando indices das minhas skins
                    
                    let cell = SKSpriteNode(imageNamed: "boxSmall")
                    
                    let skinType = Skins.types[Int(skin.index)]
                    
                    cell.addChild(SKSpriteNode(imageNamed: skinType.imageName))
                    
                    skinsArray.append(cell)
                }
                
                //Skins bloqueadas
                var skinIndex = 0
                for skinType in Skins.types {
                    if(!mySkins.containsObject(skinIndex)) {
                        let cell = SKSpriteNode(imageNamed: "boxSmall")
                        cell.addChild(SKSpriteNode(imageNamed: skinType.imageName))
                        skinsArray.append(cell)
                    }
                    skinIndex++
                }
                
                self.skinsScrollNode = ScrollNode(name: "skins", x: 667, y: 466, align: .center, cells: skinsArray, spacing: 0, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: true, scaleDistance:1334/4 + 100)
                self.addChild(skinsScrollNode)
                
                break
                
            case states.beforeMission:
                self.player.hidden = false
                self.skinsScrollNode.removeFromParent()
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
                                    println("Tap em uma skin")
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
