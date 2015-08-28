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
        case multiplayer
        case options
        case credits
    }
    
    var state = states.mainMenu
    var nextState = states.mainMenu
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        self.addChild(Button(name: "buttonPlay", textureName: "buttonYellow", text:"SINGLEPLAYER", x: 517, y: 263, align:.center))
        self.addChild(Button(name: "buttonPlayOnline", textureName: "buttonYellow", text:"MULTIPLAYER", x: 517, y: 387, align:.center))
        self.addChild(Button(name: "buttonOptions", textureName: "buttonBlueSmall", text:"OPTIONS", x: 550, y: 511, align:.center))
        self.addChild(Button(name: "buttonCredits", textureName: "buttonBlueSmall", text:"CREDITS", x: 550, y: 613, align:.center))
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
                self.view!.presentScene(MissionScene(), transition: Config.defaultGoTransition)
                break
                
            case states.multiplayer:
                self.view!.presentScene(LobbyScene(), transition: Config.defaultGoTransition)
                break
                
            case states.options:
                self.view!.presentScene(OptionsScene(), transition: Config.defaultGoTransition)
                break
                
            case states.credits:
                self.view!.presentScene(CreditsScene(), transition: Config.defaultGoTransition)
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
                    if (self.childNodeWithName("buttonPlayOnline")!.containsPoint(location)) {
                        self.nextState = .multiplayer
                        return
                    }
                    if (self.childNodeWithName("buttonOptions")!.containsPoint(location)) {
                        self.nextState = .options
                        return
                    }
                    if (self.childNodeWithName("buttonCredits")!.containsPoint(location)) {
                        self.nextState = .credits
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
