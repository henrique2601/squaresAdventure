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
        case tutorial1
    }
    //variavel para teste deve ser substituida por uma que fique salva no banco de dados
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var tutorialD:Bool!
    

    var state = states.mainMenu
    var nextState = states.mainMenu
    
    //Buttons
    var buttonPlay:Button!
    var buttonPlayOnline:Button!
    var buttonOptions:Button!
    var buttonBuyCoin:Button!
    var buttonVideoCoin:Button!

    var tutorial1:Control!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        if let _ = self.playerData.tutorial {
            
        } else {
            self.playerData.tutorial = MemoryCard.sharedInstance.newTutorial()
        }
        
        self.tutorialD = self.playerData.tutorial!.tutorial0!.boolValue
        
        self.addChild(Control(textureName: "mainMenuBackground", x:-49, y:-32, xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.buttonPlay = Button(textureName: "buttonPink", text:"SINGLEPLAYER" , x: 519, y: 428 , xAlign: .center, yAlign: .center, fontColor:.white)
        self.addChild(self.buttonPlay)
        
        self.buttonPlayOnline = Button(textureName: "buttonPink", text:"MULTIPLAYER", x: 519, y: 548, xAlign: .center, yAlign: .center, fontColor:.white)
        self.addChild(self.buttonPlayOnline)
        
        self.buttonOptions = Button(textureName: "buttonSandSquareSmall", icon:"settings", x: 1236, y: 20, xAlign: .right, yAlign: .up)
        self.addChild(self.buttonOptions)
        
        //self.buttonBuyCoin = Button(textureName: "buycoins", x: 1074, y: 26, xAlign: .center, yAlign: .center)
        //self.addChild(self.buttonBuyCoin)
        
        //self.buttonVideoCoin = Button(textureName: "earncoins", x: 1074, y: 118, xAlign: .center, yAlign: .center)
        //self.addChild(self.buttonVideoCoin)
        
        if (!tutorialD.boolValue) {
        
            self.nextState = states.tutorial1
            
            self.playerData.tutorial?.tutorial0 = NSNumber(bool: true)
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
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
                
            case states.tutorial1:
                
                self.tutorial1 = Control(textureName: "tutorialEn0", x: 30, y: 445, xAlign: .center, yAlign: .center)
                self.addChild(self.tutorial1)
                self.blackSpriteNode.hidden = false
                self.buttonPlay.zPosition += 1
                self.tutorial1.zPosition = self.buttonPlay.zPosition
                self.buttonPlayOnline.zPosition -= 1
                self.buttonOptions.zPosition -= 1
                
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
                
            case states.tutorial1:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonPlay.containsPoint(location)) {
                        self.nextState = .towers
                        return
                    }
                    if (self.buttonPlayOnline.containsPoint(location)) {
                        return
                    }
                    if (self.buttonOptions.containsPoint(location)) {
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
