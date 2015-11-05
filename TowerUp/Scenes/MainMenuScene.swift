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
        case inApp
    }
    
    var state = states.mainMenu
    var nextState = states.mainMenu
    
    //Buttons
    var buttonPlay:Button!
    var buttonPlayOnline:Button!
    var buttonOptions:Button!
    var buttonBuyCoin:Button!
    var buttonVideoCoin:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        self.addChild(Control(textureName: "mainMenuBackground", xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.buttonPlay = Button(textureName: "singleplayer" , x: 372, y: 266 , xAlign: .center, yAlign: .center)
        self.addChild(self.buttonPlay)
        
        self.buttonPlayOnline = Button(textureName: "multiplayer", x: 372, y: 486, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonPlayOnline)
        
        self.buttonOptions = Button(textureName: "options", x: 1218, y: 640, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonOptions)
        
        //self.buttonBuyCoin = Button(textureName: "buycoins", x: 1074, y: 26, xAlign: .center, yAlign: .center)
        //self.addChild(self.buttonBuyCoin)
        
        //self.buttonVideoCoin = Button(textureName: "earncoins", x: 1074, y: 118, xAlign: .center, yAlign: .center)
        //self.addChild(self.buttonVideoCoin)
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
                self.view!.presentScene(TowersScene(), transition: Config.defaultTransition)
                break
                
            case states.multiplayer:
                self.view!.presentScene(LobbyScene(), transition: Config.defaultTransition)
                break
                
            case states.options:
                self.view!.presentScene(OptionsScene(), transition: Config.defaultTransition)
                break
                
            case states.credits:
                self.view!.presentScene(CreditsScene(), transition: Config.defaultTransition)
                break
                
            case states.inApp:
                self.view!.presentScene(InAppScene(), transition: Config.defaultTransition)
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
                   // if (self.buttonBuyCoin.containsPoint(location)) {
                      //  self.nextState = .inApp
                    // return
                    //}

                }
                break
                
            default:
                break
            }
        }
    }
}
