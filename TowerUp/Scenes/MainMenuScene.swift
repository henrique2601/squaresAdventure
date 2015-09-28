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
    
    //Buttons
    var buttonPlay:Button!
    var buttonPlayOnline:Button!
    var buttonOptions:Button!
    var buttonCredits:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        self.addChild(Control(textureName: "mainMenuBackground", xAlign: .center, yAlign: .center))
        
        self.buttonPlay = Button(textureName: "buttonYellow", text:"SINGLEPLAYER", x: 517, y: 263, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonPlay)
        
        self.buttonPlayOnline = Button(textureName: "buttonYellow", text:"MULTIPLAYER", x: 517, y: 387, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonPlayOnline)
        
        self.buttonOptions = Button(textureName: "buttonBlueSmall", text:"OPTIONS", x: 550, y: 511, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonOptions)
        
        self.buttonCredits = Button(textureName: "buttonBlueSmall", text:"CREDITS", x: 550, y: 613, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonCredits)
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
                
            case states.towers:
                self.view!.presentScene(TowersScene(), transition: Config.defaultGoTransition)
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.mainMenu:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonPlay.containsPoint(location)) {
                        self.nextState = .towers
                        return
                    }
                    if (self.buttonPlayOnline.containsPoint(location)) {
                        self.nextState = .multiplayer
                        return
                    }
                    if (self.buttonOptions.containsPoint(location)) {
                        self.nextState = .options
                        return
                    }
                    if (self.buttonCredits.containsPoint(location)) {
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
