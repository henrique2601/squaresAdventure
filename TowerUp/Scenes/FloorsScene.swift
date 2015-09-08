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
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var floorsScrollNone:ScrollNode!
    
    var selectedTower:TowerData!
    
    var boxCoins:Control!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        self.boxCoins = Control(name: "boxCoins", textureName: "boxCoins", x: 1058, y: 20, xAlign: .right, yAlign: .up)
        self.boxCoins.addChild(Label(name: "lebelCoins", color: GameColors.black, textureName: self.playerData.coins.description, x: 160, y: 39))
        self.addChild(self.boxCoins)
        
        var floorsArray = Array<SKSpriteNode>()
        var towerIndex = 0
        
        for tower in self.playerData.towers {
            if(MapManager.tower == towerIndex) {
                self.selectedTower = tower as! TowerData//Encontrou torre selecionada
                break
            }
            towerIndex++
        }
        
        //Andares da torre selecionada desbloqueados que foram salvos no CoreData
        var floorIndex = 0
        let towerType = Towers.types[towerIndex]
        
        for floor in self.selectedTower.floors {
            if(floorIndex < towerType.floorCount){
                let cell = SKSpriteNode(imageNamed: "boxSmall")//TODO: imagem do andar
                
                var labelName = Label(name: "labelFloorName", color: GameColors.black, textureName: "Floor " + (floorIndex + 1).description, x: 0, y: 0)
                cell.addChild(labelName)
                
                floorsArray.append(cell)
                floorIndex++
            }
        }
        
        //Andares bloqueados, mostrar cadeado
        for (0; floorIndex < towerType.floorCount; floorIndex++) {
            let cell = SKSpriteNode(imageNamed: "boxSmall")//TODO: imagem do andar
            
            var spriteNode = SKSpriteNode(imageNamed: "boxSmallLocked")
            cell.addChild(spriteNode)
            
            var labelName = Label(name: "labelFloorName", color: GameColors.black, textureName: "Locked", x: 0, y: 0)
            cell.addChild(labelName)
            
            floorsArray.append(cell)
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
                self.view!.presentScene(BeforeMissionScene(), transition: Config.defaultGoTransition)
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
                    
                    if (self.floorsScrollNone.containsPoint(location)) {
                        if(touch.tapCount > 0) {
                            
                            var i = 0
                            let locationInScrollNode = touch.locationInNode(self.floorsScrollNone)
                            
                            for cell in self.floorsScrollNone.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    if(i < self.selectedTower.floors.count) {
                                        MapManager.floor = i
                                        self.nextState = states.beforeMission
                                    } else {
                                        println("Andar \(i) ainda não foi desbloqueada")
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
