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
        case tutorial2
    }
    
  
    var tutorialD:Bool!

   
    var tutorial2:Control!
    
    var state = states.towers
    var nextState = states.towers
    
    var playerData = MemoryCard.sharedInstance.playerData!
    
    var towersScrollNode:ScrollNode!
    
    var boxCoins:BoxCoins!
    
    var buttonBack:Button!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(textureName: "background", x:-49, y:-32, xAlign: .center, yAlign: .center))
        
        self.tutorialD = self.playerData.tutorial!.tutorial1!.boolValue
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.boxCoins = BoxCoins()
        self.addChild(self.boxCoins)
        
        var towersArray = Array<SKSpriteNode>()
        var towerIndex = 0
        
        //Torres desbloqueadas que foram salvas no CoreData
        for item in self.playerData.towers as NSOrderedSet {
            let tower = item as! TowerData
            if towerIndex < Towers.types.count {
                let towerType = Towers.types[towerIndex]
                let cell = SKSpriteNode(imageNamed: "towerBox")
                let spriteNode = SKSpriteNode(imageNamed: "towerBoxBackground")
                spriteNode.zPosition = cell.zPosition + CGFloat(2)
                cell.addChild(spriteNode)
                
                //towerType.tileset
                let backgroundNode = SKSpriteNode(imageNamed: Towers.types[towerIndex].tileset + "Tower")
                backgroundNode.zPosition = cell.zPosition + CGFloat(1)
                cell.addChild(backgroundNode)
                
                let labelName = Label(text: (towerIndex + 1).description, x: 0, y: -109)
                labelName.zPosition = cell.zPosition + CGFloat(3)
                
                var stars = 0
                for item in tower.floors as NSOrderedSet {
                    let floor = item as! FloorData
                    stars += floor.stars.intValue
                }
                
                let labelProgress = Label(text: (stars).description + "/" + (towerType.floorTypes.count * 3).description, x: 42, y: 176)
                labelProgress.zPosition = cell.zPosition + CGFloat(3)
                cell.addChild(labelName)
                cell.addChild(labelProgress)
                
                towersArray.append(cell)
            }
            towerIndex += 1
        }

    
        //Torres bloqueadas, mostrar cadeado
        for towerIndex in 0 ..< Towers.types.count {
            let cell = SKSpriteNode(imageNamed: "towerBox")
            let spriteNode = SKSpriteNode(imageNamed: "towerBoxLocked")
            spriteNode.zPosition = cell.zPosition + 1
            cell.addChild(spriteNode)
            
            let labelName = Label(text: "Locked")
            cell.addChild(labelName)
            
            towersArray.append(cell)
        }
        
        //TODO: torre "?"
        
        self.towersScrollNode = ScrollNode(x: 667, y: 466, cells:towersArray, spacing:5, scaleNodes:true, scaleDistance:1334/4 + 100, index:self.playerData.lastPlayedTower.intValue)
        
        self.addChild(self.towersScrollNode)
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        if (!tutorialD){
            
            self.nextState = states.tutorial2
            
            self.playerData.tutorial?.tutorial1 = NSNumber(value: true)
            
        }

        
        
    }
    
    override func update(currentTime: TimeInterval) {
        super.update(currentTime: currentTime)
        if(self.state == self.nextState) {
            switch (self.state) {
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.floors:
                self.view!.presentScene(FloorsScene(), transition: Config.defaultTransition)
                break
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultTransition)
                break
                
            case states.tutorial2:
                
                self.tutorial2 = Control(textureName: "tutorialEn1", x: 120, y: 30, xAlign: .center, yAlign: .center)
                self.addChild(self.tutorial2)
                self.blackSpriteNode.isHidden = false
                self.towersScrollNode.zPosition += 1
                self.tutorial2.zPosition = self.towersScrollNode.zPosition + 1
                self.buttonBack.zPosition -= 1

                break
                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.towers:
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
                    if (self.buttonBack.contains(location)) {
                        self.nextState = .mainMenu
                        return
                    }
                    
                    if(self.boxCoins.contains(location)) {
                        self.boxCoins.containsPoint()
                    }
                    
                    if (self.towersScrollNode.contains(location)) {
                        if(touch.tapCount > 0) {
                            
                            var i = 0
                            let locationInScrollNode = touch.location(in: self.towersScrollNode)
                            
                            for cell in self.towersScrollNode.cells {
                                if(cell.contains(locationInScrollNode)) {
                                    if(i < self.playerData.towers.count) {
                                        MapManager.tower = i
                                        
                                        self.nextState = .floors
                                    } else {
                                        print("Torre \(i) ainda não foi desbloqueada")
                                    }
                                    return
                                }
                                i += 1
                            }
                        }
                    }
                }
                break
                
                
            case states.tutorial2:
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
                    if (self.buttonBack.contains(location)) {
                        self.nextState = .mainMenu
                        return
                    }
                    
                    if (self.towersScrollNode.contains(location)) {
                        if(touch.tapCount > 0) {
                            
                            var i = 0
                            let locationInScrollNode = touch.location(in: self.towersScrollNode)
                            
                            for cell in self.towersScrollNode.cells {
                                if(cell.contains(locationInScrollNode)) {
                                    if(i < self.playerData.towers.count) {
                                        MapManager.tower = i
                                        
                                        self.nextState = .floors
                                    } else {
                                        print("Torre \(i) ainda não foi desbloqueada")
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
