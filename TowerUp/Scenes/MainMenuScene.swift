//
//  MainMenuScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuScene: GameScene {
    
    enum states {
        case mainMenu
        case towers
        case options
        case credits
    }
    
    var state = states.mainMenu
    var nextState = states.mainMenu
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        self.addChild(Label(name: "labelTitle", textureName: "MainMenuScene", x: 667, y: 130, align:.center))
        
        self.addChild(Button(name: "buttonPlay", textureName: "buttonYellow", text:"PLAY", x: 550, y: 189, align:.center))
        self.addChild(Button(name: "buttonOptions", textureName: "buttonYellow", text:"OPTIONS", x: 550, y: 287, align:.center))
        self.addChild(Button(name: "buttonCredits", textureName: "buttonYellow", text:"CREDITS", x: 550, y: 385, align:.center))
        self.addChild(Button(name: "buttonD", textureName: "buttonYellow", text:"BUTTON D", x: 550, y: 483, align:.center))
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
                
            case states.towers:
                self.view!.presentScene(TowersScene(), transition: Config.defaultTransition)
                break
                
            case states.options:
                self.view!.presentScene(OptionsScene(), transition: Config.defaultTransition)
                break
                
            case states.credits:
                self.view!.presentScene(CreditsScene(), transition: Config.defaultTransition)
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
            case states.mainMenu:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonPlay")!.containsPoint(location)) {
                        self.nextState = .towers
                        return
                    }
                    
                    if (self.childNodeWithName("buttonOptions")!.containsPoint(location)) {
                        //self.nextState = .options
                        return
                    }
                    if (self.childNodeWithName("buttonCredits")!.containsPoint(location)) {
                        //self.nextState = .credits
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
