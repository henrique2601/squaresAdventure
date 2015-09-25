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
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var towersScrollNode:ScrollNode!
    
    var boxCoins:Control!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        self.boxCoins = Control(name: "boxCoins", textureName: "boxCoins", x: 1058, y: 20, xAlign: .right, yAlign: .up)
        self.boxCoins.addChild(Label(name: "lebelCoins", color: GameColors.black, textureName: self.playerData.coins.description, x: 160, y: 39))
        self.addChild(self.boxCoins)
        
        var towersArray = Array<SKSpriteNode>()
        var towerIndex = 0
        
        //Torres desbloqueadas que foram salvas no CoreData
        for item in self.playerData.towers as NSOrderedSet {
            let tower = item as! TowerData
            if towerIndex < Towers.types.count {
                let towerType = Towers.types[towerIndex]
                let cell = SKSpriteNode(imageNamed: "towerBox")
                let labelName = Label(name: "labelTowerName", color: GameColors.black, textureName: "Tower " + (towerIndex + 1).description, x: 0, y: 0)
                let labelProgress = Label(name: "labelTowerProgress", color: GameColors.black, textureName: (tower.floors.count - 1).description + "/" + towerType.floorCount.description, x: 0, y: 64)
                cell.addChild(labelName)
                cell.addChild(labelProgress)
                
                towersArray.append(cell)
            }
            towerIndex++
        }

    
        //Torres bloqueadas, mostrar cadeado
        for (0; towerIndex < Towers.types.count; towerIndex++) {
            let cell = SKSpriteNode(imageNamed: "towerBox")
            let spriteNode = SKSpriteNode(imageNamed: "towerBoxLocked")
            spriteNode.zPosition = cell.zPosition + 1
            cell.addChild(spriteNode)
            
            let labelName = Label(name: "labelTowerName", color: GameColors.black, textureName: "Locked", x: 0, y: 0)
            cell.addChild(labelName)
            
            towersArray.append(cell)
        }
        
        //TODO: torre "?"
        
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.towers:
                for touch in (touches ) {
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
                                    if(i < self.playerData.towers.count) {
                                        MapManager.tower = i
                                        self.nextState = .floors
                                    } else {
                                        print("Torre \(i) ainda não foi desbloqueada")
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
