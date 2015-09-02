//
//  Towers.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class TowersScene: GameScene {
    
    enum states {
        case towers
        case floors
        case mainMenu
    }
    
    var state = states.towers
    var nextState = states.towers
    
    var playerData = AppDelegate.memoryCard.playerData
    
    var towersScrollNode:ScrollNode!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        var towersArray = Array<SKSpriteNode>()
        var i = 0
        for tower in self.playerData.towers {
            let cell = SKSpriteNode(imageNamed: "towerBox")//TODO: imagem da torre
            if(GameMath.isTowerUnlocked(Int(self.playerData.lastFloorUnlocked), towerIndex: i)) {
                var progress = min(Int(self.playerData.lastFloorUnlocked) - (i * 10) - 1, 10)
                var labelName = Label(name: "labelTowerName", color: GameColors.black, textureName: "Tower " + i.description, x: 0, y: 0)
                var labelProgress = Label(name: "labelTowerProgress", color: GameColors.black, textureName: progress.description + "/10", x: 0, y: 64)
                cell.addChild(labelName)
                cell.addChild(labelProgress)
            } else {
                var spriteNode = SKSpriteNode(imageNamed: "towerBoxLocked")
                cell.addChild(spriteNode)
                
                var labelName = Label(name: "labelTowerName", color: GameColors.black, textureName: "Locked", x: 0, y: 0)
                cell.addChild(labelName)
            }
            towersArray.append(cell)
            i++
        }
        
        self.towersScrollNode = ScrollNode(name: "scrollNode", x: 667, y: 466, align: .center, cells:towersArray, spacing:1, scaleNodes:true, scaleDistance:1334/4 + 100)
        
        self.addChild(self.towersScrollNode)
        
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
                
            case states.floors:
                self.view!.presentScene(FloorsScene(), transition: Config.defaultGoTransition)
                break
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultBackTransition)
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
            case states.towers:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .mainMenu
                        return
                    }
                    
                    if (self.towersScrollNode.containsPoint(location)) {
                        if(touch.tapCount > 0) {
                            
                            var i = 0
                            let locationInScrollNode = touch.locationInNode(self.towersScrollNode)
                            
                            for cell in self.towersScrollNode.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    if(GameMath.isTowerUnlocked(Int(self.playerData.lastFloorUnlocked), towerIndex: i)) {
                                        MapManager.tower = i
                                        self.nextState = .floors
                                    } else {
                                        println("Torre \(i) ainda não foi desbloqueada")
                                    }
                                    return
                                }
                                i++
                            }
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
