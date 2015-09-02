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
        
        var towersArray = Array<SKSpriteNode>()
        var i = 0
        for tower in playerData.towers {
            let cell = SKSpriteNode(imageNamed: "towerBox")
            if((Int(self.playerData.lastFloorUnlocked) - 1) / 10 >= i) {
                //Teste com label
                var label = Label(name: "labelTowerName", color: GameColors.black, textureName: "Tower " + i.description, x: 0, y: 0)
                cell.addChild(label)
            } else {
                var spriteNode = SKSpriteNode(imageNamed: "towerBoxLocked")
                cell.addChild(spriteNode)
            }
            towersArray.append(cell)
            i++
        }
        
        self.towersScrollNode = ScrollNode(name: "scrollNode", x: 667, y: 375, align: Control.xAlignments.center, cells:towersArray, spacing:50, scaleNodes:true, scaleDistance:1000)
        
        self.addChild(self.towersScrollNode)
        
        self.addChild(Button(name: "buttonTower0", textureName: "buttonYellow", text:"TOWER 0", x: 550, y: 189, align:.center))
        
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
                    
                    if (self.childNodeWithName("buttonTower0")!.containsPoint(location)) {
                        self.nextState = .floors
                        return
                    }
                    
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .mainMenu
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
