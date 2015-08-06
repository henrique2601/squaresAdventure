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
        case mainMenu
    }
    
    var state = states.towers
    var nextState = states.towers
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(name: "towersBackground", x:0, y:0, align:.center))
        
        self.addChild(Label(name: "labelTitle", textureName: "TowersScene", x: 667, y: 130, align:.center))
        
        self.addChild(Button(name: "buttonA", textureName: "buttonYellow", text:"BUTTON A", x: 550, y: 189, align:.center))
        self.addChild(Button(name: "buttonB", textureName: "buttonYellow", text:"BUTTON B", x: 550, y: 287, align:.center))
        self.addChild(Button(name: "buttonC", textureName: "buttonYellow", text:"BUTTON C", x: 550, y: 385, align:.center))
        self.addChild(Button(name: "buttonD", textureName: "buttonYellow", text:"BUTTON D", x: 550, y: 483, align:.center))
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGrayLeft", x: 20, y: 652, xAlign:.left, yAlign:.down))
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
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultTransition)
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
                }
                break
                
            default:
                break
            }
        }
    }
}
