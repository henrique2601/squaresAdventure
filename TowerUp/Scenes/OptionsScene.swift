//
//  OptionsScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit
import ParseFacebookUtilsV4

class OptionsScene: GameScene {
    enum states {
        case options
        case deleteSavedGame
        case chooseControls
        case mainMenu
        case invite
        case soundConfig
    }
    
    var state = states.options
    var nextState = states.options
    
    var soundConfigBox:SoundConfigBox!
    var deleteSavedGameBox:Box!
    
    var chooseControlsScrollNode:ScrollNode!
    
    var labelLoading:Label!
    var labelScale: CGFloat! = 1
    var growing : Bool = true
    
    var buttonDeleteSavedGame:Button!
    var buttonChooseControls:Button!
    var buttonBack:Button!
    //var buttonInvite:Button!
    var buttonSoundConfig:Button!
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var loadingImage:SKSpriteNode!
    
    lazy var deathEffect:SKAction = {
        return SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI * 2), duration: 1))
        }()
    
////////////////////////////////
    

///////////////////////////////
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = GameColors.blue
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.addChild(Control(textureName: "background", x:-49, y:-32, xAlign: .center, yAlign: .center))
        
        self.buttonChooseControls = Button(textureName: "buttonSand", icon:"controller", x: 517, y: 181)
        self.addChild(self.buttonChooseControls)
        
        self.buttonSoundConfig = Button(textureName: "buttonSand", icon:"music", x: 517, y: 325)
        
//        self.buttonInvite = Button(textureName: "buttonSand", icon:"invite", x: 347, y: 397)
//        self.addChild(self.buttonInvite)
        
        self.buttonDeleteSavedGame = Button(textureName: "buttonSand", icon:"delete", x: 517, y: 469)
        self.addChild(self.buttonDeleteSavedGame)
        
        self.addChild(self.buttonSoundConfig)
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.buttonBack.zPosition = Config.HUDZPosition * 2 + 1
        self.addChild(self.buttonBack)
    }
    
    override func update(currentTime: TimeInterval) {
        super.update(currentTime: currentTime)
        if(self.state == self.nextState){
            switch (self.state) {
                
            case states.invite:
                
                break
                
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
                
                if let teste = self.loadingImage {
                    teste.removeFromParent()
                }
                
                self.blackSpriteNode.isHidden = true
                
                break
                
            case states.chooseControls:
                
                var controlsArray = Array<SKSpriteNode>()
                
                var spriteNode = SKSpriteNode(imageNamed: "useLeftSliderAndScreenRight")
                controlsArray.append(spriteNode)
                
                spriteNode = SKSpriteNode(imageNamed: "useButtons")
                controlsArray.append(spriteNode)
                
                self.chooseControlsScrollNode = ScrollNode(x: 667, y: 466, cells:controlsArray, spacing:1, scaleNodes:true, scaleDistance:1334/4 + 100, index:self.playerData!.configControls.intValue - 1)
                self.addChild(self.chooseControlsScrollNode)
                
                let size = self.size.width > self.size.height ? self.size.width : self.size.height
                
                self.blackSpriteNode.isHidden = false
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.chooseControlsScrollNode.zPosition = self.blackSpriteNode.zPosition + 1
                
                break
                
            case states.invite:
                
                self.loadingImage = SKSpriteNode(imageNamed: "circleLoading")
                self.loadingImage.position = CGPoint(x: 1334/4, y: -750/4)
                self.addChild(self.loadingImage)
                
                self.loadingImage.run(self.deathEffect)
                
                self.blackSpriteNode.isHidden = false
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.loadingImage.zPosition = self.blackSpriteNode.zPosition + 1
                
                //self.inviteFriends(nextCursor: nil, limit: 50)
                
                break
                
            case states.soundConfig:
                
                self.soundConfigBox = SoundConfigBox()
                
                let buttonOk = Button(textureName: "buttonSandSmall", text: "Ok", x: 53, y: 253)
                buttonOk.addHandler(handler: {
                    self.nextState = .options
                    if let parent = buttonOk.parent {
                        parent.removeFromParent()
                    }
                })
                
                self.addChild(self.soundConfigBox)
                self.soundConfigBox.addChild(buttonOk)
                
                self.blackSpriteNode.isHidden = false
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.soundConfigBox.zPosition = self.blackSpriteNode.zPosition + 1
                
                break
                
            case states.deleteSavedGame:
                self.deleteSavedGameBox = Box(textureName: "messegeBox")
                
                self.deleteSavedGameBox.addChild(Label(text: "Delete saved game?", x:256, y:64))
                
                let buttonOk = Button(textureName: "buttonRedSmall", text: "Ok", x: 266, y: 162)
                buttonOk.addHandler(handler: {
                    MemoryCard.sharedInstance.reset()
                    self.nextState = .options
                    if let parent = buttonOk.parent {
                        parent.removeFromParent()
                    }
                })
                
                let buttonCancel = Button(textureName: "buttonGraySmall", text: "Cancel", x: 12, y: 162)
                buttonCancel.addHandler(handler: {
                    self.nextState = .options
                    if let parent = buttonCancel.parent {
                        parent.removeFromParent()
                    }
                })
                
                self.addChild(self.deleteSavedGameBox)
                self.deleteSavedGameBox.addChild(buttonCancel)
                self.deleteSavedGameBox.addChild(buttonOk)
                
                self.blackSpriteNode.isHidden = false
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.deleteSavedGameBox.zPosition = self.blackSpriteNode.zPosition + 1
                
                break
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultTransition)
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.chooseControls:
                
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
                    if (self.buttonBack.contains(location)) {
                        self.nextState = .options
                        return
                    }
                    
                    if(touch.tapCount > 0) {
                        if (self.chooseControlsScrollNode.contains(location)) {
                            
                            var i = 1
                            let locationInScrollNode = touch.location(in: self.chooseControlsScrollNode)
                            
                            for cell in self.chooseControlsScrollNode.cells {
                                if(cell.contains(locationInScrollNode)) {
                                    let playerData = MemoryCard.sharedInstance.playerData
                                    playerData!.configControls = NSNumber(value: i)
                                    self.nextState = .options
                                    return
                                }
                                i += 1
                            }
                        } else {
                            self.nextState = .options
                        }
                    }
                }
                
                break
                
            case states.invite:
                
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
                    if (self.buttonBack.contains(location)) {
                        self.nextState = .options
                        return
                    }
                }
                
                break
                
            case states.deleteSavedGame:
                for touch in touches {
                    let location = touch.location(in: self)
                    if !(self.deleteSavedGameBox.contains(location)) {
                        self.deleteSavedGameBox.removeFromParent()
                        self.nextState = .options
                    }
                }
                break
                
            case states.soundConfig:
                for touch in touches {
                    let location = touch.location(in: self)
                    
                    if !(self.soundConfigBox.contains(location)) {
                        self.soundConfigBox.removeFromParent()
                        self.nextState = .options
                    }
                }
                break
                
            case states.options:
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
                    if (self.buttonDeleteSavedGame.contains(location)) {
                        self.nextState = .deleteSavedGame
                        return
                    }
                    
                    if (self.buttonChooseControls.contains(location)) {
                        self.nextState = .chooseControls
                        return
                    }

//                    if (self.buttonInvite.containsPoint(location)) {
//                        //self.inviteFriends(nil, limit: 50)
//                        self.nextState = .invite
//                        return
//                    }
                    
                    if (self.buttonSoundConfig.contains(location)) {
                        self.nextState = .soundConfig
                        return
                    }
                    
                    if (self.buttonBack.contains(location)) {
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
