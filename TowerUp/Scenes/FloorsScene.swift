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
        case tutorial3
    }
    
    //variavel para teste deve ser substituida por uma que fique salva no banco de dados
    
    var tutorialD:Bool!
    
    var tutorial3:Control!
    
    var state = states.floors
    var nextState = states.floors
    
    var playerData = MemoryCard.sharedInstance.playerData!
    
    var floorsScrollNone:ScrollNode!
    
    var selectedTower:TowerData!
    
    var boxCoins:BoxCoins!
    
    var buttonBack:Button!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(textureName: "background", x:-49, y:-32, xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.tutorialD = self.playerData.tutorial!.tutorial2!.boolValue
        
        self.boxCoins = BoxCoins()
        self.addChild(self.boxCoins)
        
        var floorsArray = Array<SKSpriteNode>()
        
        self.selectedTower = self.playerData.towers.object(at: MapManager.tower) as! TowerData
        
        
        //Andares da torre selecionada desbloqueados que foram salvos no CoreData
        var floorIndex = 0
        let towerType = Towers.types[MapManager.tower]
        
        for item in self.selectedTower.floors as NSOrderedSet {
            
            let floorData = item as! FloorData
            
            if(floorIndex < towerType.floorTypes.count){
                let cell = SKSpriteNode(imageNamed: Towers.types[MapManager.tower].tileset + "Floor")
                
                for i in 0 ..< floorData.stars.intValue {
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
                floorIndex += 1
            }
        }
        
        //Andares bloqueados, mostrar cadeado
        for _ in 0 ..< towerType.floorTypes.count {
            let cell = SKSpriteNode(imageNamed: "boxSmall")
            
            let spriteNode = SKSpriteNode(imageNamed: "boxSmallLocked")
            spriteNode.zPosition = cell.zPosition + 1
            cell.addChild(spriteNode)
            
            let labelName = Label(text: "Locked")
            cell.addChild(labelName)
            
            floorsArray.append(cell)
        }
        
        self.floorsScrollNone = ScrollNode(x: 667, y: 466, cells:floorsArray, spacing: 1, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes:true, scaleDistance:1334/4 + 100, index: MemoryCard.sharedInstance.currentTower().lastPlayedFloor.intValue)
        self.addChild(self.floorsScrollNone)
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        if (!tutorialD){
            
            self.nextState = states.tutorial3
            
            self.playerData.tutorial?.tutorial2 = NSNumber(value: true)
            
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if(self.state == self.nextState) {
            switch (self.state) {
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.beforeMission:
                self.view!.presentScene(BeforeMissionScene(), transition: Config.defaultTransition)
                break
                
            case states.towers:
                self.view!.presentScene(TowersScene(), transition: Config.defaultTransition)
                break
                
            case states.tutorial3:
                
                self.tutorial3 = Control(textureName: "tutorialEn2", x: 120, y: 35, xAlign: .center, yAlign: .center)
                self.addChild(self.tutorial3)
                self.blackSpriteNode.isHidden = false
                self.floorsScrollNone.zPosition += 1
                self.tutorial3.zPosition = self.floorsScrollNone.zPosition + 1
                self.floorsScrollNone.zPosition -= 1
                
                break

                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.floors:
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
                    if (self.buttonBack.contains(location)) {
                        self.nextState = .towers
                        return
                    }
                    
                    if(self.boxCoins.contains(location)) {
                        self.boxCoins.containsPoint()
                    }
                    
                    if (self.floorsScrollNone.contains(location)) {
                        if(touch.tapCount > 0) {
                            
                            var i = 0
                            let locationInScrollNode = touch.location(in: self.floorsScrollNone)
                            
                            for cell in self.floorsScrollNone.cells {
                                if(cell.contains(locationInScrollNode)) {
                                    if(i < self.selectedTower.floors.count) {
                                        MapManager.floor = i
                                        self.nextState = states.beforeMission
                                    } else {
                                        print("Andar \(i) ainda não foi desbloqueada")
                                    }
                                    return
                                }
                                i += 1
                            }
                        }
                    }
                }
                break
            case states.tutorial3:
                
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
                    if (self.floorsScrollNone.contains(location)) {
                        if(touch.tapCount > 0) {
                            
                            var i = 0
                            let locationInScrollNode = touch.location(in: self.floorsScrollNone)
                            
                            for cell in self.floorsScrollNone.cells {
                                if(cell.contains(locationInScrollNode)) {
                                    if(i < self.selectedTower.floors.count) {
                                        MapManager.floor = i
                                        self.nextState = states.beforeMission
                                    } else {
                                        print("Andar \(i) ainda não foi desbloqueada")
                                    }
                                    return
                                }
                                i += 1
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
