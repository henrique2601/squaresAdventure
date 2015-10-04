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
    
    var buttonBack:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(textureName: "mainMenuBackground", xAlign: .center, yAlign: .center))
        
        self.boxCoins = BoxCoins()
        self.addChild(self.boxCoins)
        
        var floorsArray = Array<SKSpriteNode>()
        
        self.selectedTower = self.playerData.towers.objectAtIndex(MapManager.tower) as! TowerData
        
        
        //Andares da torre selecionada desbloqueados que foram salvos no CoreData
        var floorIndex = 0
        let towerType = Towers.types[MapManager.tower]
        
        for item in self.selectedTower.floors as NSOrderedSet {
            
            let floorData = item as! FloorData
            
            if(floorIndex < towerType.floorTypes.count){
                let cell = SKSpriteNode(imageNamed: "boxSmall")//TODO: imagem do andar
                
                for(var i = 0; i <= floorData.stars.integerValue; i++) {
                    switch(i){
                    case 0:
                        break
                    case 1:
                        let star1 = Control(textureName: "starSmall", x: -106, y:32)
                        cell.addChild(star1)
                        break
                    case 2:
                        let star2 = Control(textureName: "starSmall", x: -32, y:32)
                        cell.addChild(star2)
                        break
                    case 3:
                        let star3 = Control(textureName: "starSmall", x: 42, y:32)
                        cell.addChild(star3)
                        break
                        
                    default:
                        break
                    }
                }
                
                let labelName = Label(text: "Floor " + (floorIndex + 1).description, x: 0, y: 0)
                cell.addChild(labelName)
                
                floorsArray.append(cell)
                floorIndex++
            }
        }
        
        //Andares bloqueados, mostrar cadeado
        for (0; floorIndex < towerType.floorTypes.count; floorIndex++) {
            let cell = SKSpriteNode(imageNamed: "boxSmall")//TODO: imagem do andar
            
            let spriteNode = SKSpriteNode(imageNamed: "boxSmallLocked")
            spriteNode.zPosition = cell.zPosition + 1
            cell.addChild(spriteNode)
            
            let labelName = Label(text: "Locked")
            cell.addChild(labelName)
            
            floorsArray.append(cell)
        }
        
        self.floorsScrollNone = ScrollNode(x: 667, y: 466, cells:floorsArray, spacing: 1, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes:true, scaleDistance:1334/4 + 100, index: MemoryCard.sharedInstance.currentTower().lastPlayedFloor.integerValue)
        self.addChild(self.floorsScrollNone)
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.floors:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonBack.containsPoint(location)) {
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
                                        print("Andar \(i) ainda não foi desbloqueada")
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
