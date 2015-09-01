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
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        var scrollNode = ScrollNode(name: "scrollNode", textureName: "boxWhite", x: 0, y: 0, align: Control.xAlignments.center, count: 3)
        self.addChild(scrollNode)
        
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
