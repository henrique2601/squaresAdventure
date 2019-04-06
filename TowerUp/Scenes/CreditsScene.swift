//
//  CreditsScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit


class CreditsScene: GameScene {
    enum states {
        case credits
        case mainMenu
    }
    
    var state = states.credits
    var nextState = states.credits
    
    var buttonBack:Button!
    var buttonAd:Button!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.addChild(Control(textureName: "background", x:-49, y:-32, xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        self.buttonAd = Button(textureName: "buttonGraySquareSmall", text:"Ad", x: 20, y: 500, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonAd)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.credits:
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
                    if (self.buttonBack.contains(location)) {
                        self.nextState = .mainMenu
                        return
                    }
                    
                    if(self.buttonAd.contains(location)){
                    
                        //ViewController.triggerVideo
                    
                    }
                }
                break
                
            default:
                break
            }
        }
    }
    
}
