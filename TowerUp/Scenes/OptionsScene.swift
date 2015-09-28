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
        case chooseControls
        case mainMenu
    }
    
    var state = states.options
    var nextState = states.options
    
    var blackSpriteNode:SKSpriteNode!
    
    var chooseControlsScrollNode:ScrollNode!
    
    var buttonDeleteSavedGame:Button!
    var buttonChooseControls:Button!
    var buttonBack:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        self.buttonDeleteSavedGame = Button(textureName: "buttonBlueSmall", text:"DELETE", x: 20, y: 202)
        self.addChild(self.buttonDeleteSavedGame)
        
        self.buttonChooseControls = Button(textureName: "buttonBlueSmall", text:"CONTROLS", x: 20, y: 304)
        self.addChild(self.buttonChooseControls)
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.buttonBack.zPosition = Config.HUDZPosition * 2 + 1
        self.addChild(self.buttonBack)
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
                
            case states.options:
                if let teste = self.chooseControlsScrollNode {
                    teste.removeFromParent()
                }
                if let teste = self.blackSpriteNode {
                    teste.removeFromParent()
                }
                break
                
            case states.chooseControls:
                
                var controlsArray = Array<SKSpriteNode>()
                
                var spriteNode = SKSpriteNode(imageNamed: "useButtons")
                controlsArray.append(spriteNode)
                
                spriteNode = SKSpriteNode(imageNamed: "useLeftSliderAndScreenRight")
                controlsArray.append(spriteNode)
                
                self.chooseControlsScrollNode = ScrollNode(x: 667, y: 466, cells:controlsArray, spacing:1, scaleNodes:true, scaleDistance:1334/4 + 100)
                self.addChild(self.chooseControlsScrollNode)
                
                let size = self.size.width > self.size.height ? self.size.width : self.size.height
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: CGSize(width: size * 2, height: size * 2))
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.chooseControlsScrollNode.zPosition = self.blackSpriteNode.zPosition + 1
                
                break
                
            case states.deleteSavedGame:
                let box = Box(background: "messegeBox")
                
                let buttonOk = Button(textureName: "buttonRedSmall", text: "Ok", x: 266, y: 162)
                buttonOk.addHandler({
                    MemoryCard.sharedInstance.reset()
                    self.nextState = .options
                    if let parent = buttonOk.parent {
                        parent.removeFromParent()
                    }
                })
                
                let buttonCancel = Button(textureName: "buttonGraySmall", text: "Cancel", x: 12, y: 162)
                buttonCancel.addHandler({
                    self.nextState = .options
                    if let parent = buttonCancel.parent {
                        parent.removeFromParent()
                    }
                })
                
                self.addChild(box)
                box.addChild(buttonCancel)
                box.addChild(buttonOk)
                
                break
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultBackTransition)
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.chooseControls:
                
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .options
                        return
                    }
                    
                    if(touch.tapCount > 0) {
                        if (self.chooseControlsScrollNode.containsPoint(location)) {
                            
                            var i = 1
                            let locationInScrollNode = touch.locationInNode(self.chooseControlsScrollNode)
                            
                            for cell in self.chooseControlsScrollNode.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    let playerData = MemoryCard.sharedInstance.playerData
                                    playerData.configControls = NSNumber(integer: i)
                                    self.nextState = .options
                                    return
                                }
                                i++
                            }
                        } else {
                            self.nextState = .options
                        }
                    }
                }
                
                break
            case states.options:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonDeleteSavedGame.containsPoint(location)) {
                        self.nextState = .deleteSavedGame
                        return
                    }
                    
                    if (self.buttonChooseControls.containsPoint(location)) {
                        self.nextState = .chooseControls
                        return
                    }
                    
                    if (self.buttonBack.containsPoint(location)) {
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
