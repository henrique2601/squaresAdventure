//
//  FloorsScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class FloorsScene: GameScene {
    enum states {
        case floors
        case beforeMission
        case towers
    }
    
    var state = states.floors
    var nextState = states.floors
    
    var playerData = AppDelegate.memoryCard.playerData
    
    var floorsScrollNone:ScrollNode!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        var floorsArray = Array<SKSpriteNode>()
        var towerIndex = 0
        for tower in self.playerData.towers {
            if(MapManager.tower == towerIndex) {
                if let tower = tower as? TowerData {
                    var floorIndex = 0
                    for floor in tower.floors {
                        var progress = min(Int(self.playerData.lastFloorUnlocked) - (towerIndex * 10) - 1, 10)

                        let cell = SKSpriteNode(imageNamed: "boxSmall")//TODO: imagem do andar
                        if(progress >= floorIndex) {
                            
                            var labelName = Label(name: "labelFloorName", color: GameColors.black, textureName: "Floor " + floorIndex.description, x: 0, y: 0)
                            cell.addChild(labelName)
                            
                        } else {
                            
                            var spriteNode = SKSpriteNode(imageNamed: "boxSmallLocked")
                            cell.addChild(spriteNode)
                            
                            var labelName = Label(name: "labelFloorName", color: GameColors.black, textureName: "Locked", x: 0, y: 0)
                            cell.addChild(labelName)
                            
                        }
                        floorsArray.append(cell)
                        floorIndex++
                    }
                }
            }
            towerIndex++
        }
        
        self.floorsScrollNone = ScrollNode(name: "scrollNode", textureName: "boxSmall", x: 667, y: 466, align: .center, cells:floorsArray, spacing: 1, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes:true, scaleDistance:1334/4 + 100)
        self.addChild(self.floorsScrollNone)
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down))
    }
    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState) {
            switch (self.state) {
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.beforeMission:
                self.view!.presentScene(MissionScene(), transition: Config.defaultGoTransition)
                break
                
            case states.towers:
                self.view!.presentScene(TowersScene(), transition: Config.defaultBackTransition)
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
            case states.floors:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    
                    
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .towers
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
