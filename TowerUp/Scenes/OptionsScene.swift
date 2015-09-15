//
//  OptionsScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class OptionsScene: GameScene {
    enum states {
        case options
        case deleteSavedGame
        case mainMenu
    }
    
    var state = states.options
    var nextState = states.options
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        self.addChild(Button(name: "buttonDeleteSavedGame", textureName: "buttonBlueSmall", text:"DELETE", x: 20, y: 202, align:.center))
        
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
                
            case states.deleteSavedGame:
                let box = Box(background: "messegeBox")
                
                let buttonOk = Button(name: "buttonRedSmall", text: "Ok", x: 266, y: 162)
                buttonOk.addHandler({
                    MemoryCard.sharedInstance.reset()
                    self.nextState = .options
                    buttonOk.parent!.removeFromParent()
                })
                
                let buttonCancel = Button(name: "buttonGraySmall", text: "Cancel", x: 12, y: 162)
                buttonCancel.addHandler({
                    self.nextState = .options
                    buttonCancel.parent!.removeFromParent()
                })
                
                self.addChild(box)
                box.addChild(buttonCancel)
                box.addChild(buttonOk)
                
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
            case states.options:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonDeleteSavedGame")!.containsPoint(location)) {
                        self.nextState = .deleteSavedGame
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
