//
//  BeforeMissionScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class BeforeMissionScene: GameScene {
    enum states {
        case beforeMission
        case mission
        case floors
    }
    
    var state = states.beforeMission
    var nextState = states.beforeMission
    
    //
    var powerUpPageNumber = -1
    var skinPageNumber = -1
    var moveTheSkin = false
    var movethePowerUp = false
    
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        
        self.backgroundColor = GameColors.blue
        
        self.addChild(Control(name: "beforeMissionBackground", x:0, y:0, align:.center))
        
        self.addChild(Button(name: "buttonPlay", textureName: "buttonYellow", text:"GO!", x: 1000, y: 580, align:.center))
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down))
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        AppDelegate.memoryCard.newGame()
        
        self.skinPaged(self.skinPageNumber)
        self.powerUpPaged(self.powerUpPageNumber)
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
                
            case states.mission:
                self.view!.presentScene(MissionScene(), transition: Config.defaultGoTransition)
                break
                
            case states.floors:
                self.view!.presentScene(FloorsScene(), transition: Config.defaultBackTransition)
                break
                
            default:
                break
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.beforeMission:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("skin1")!.containsPoint(location)) {
                        return self.moveTheSkin = true
                    }
                    if (self.childNodeWithName("skin2")!.containsPoint(location)) {
                        return self.moveTheSkin = true
                    }
                    if (self.childNodeWithName("skin3")!.containsPoint(location)) {
                        return self.moveTheSkin = true
                    }
                    if (self.childNodeWithName("power1")!.containsPoint(location)) {
                        return self.movethePowerUp = true
                    }
                    if (self.childNodeWithName("power2")!.containsPoint(location)) {
                        return self.movethePowerUp = true
                    }
                    if (self.childNodeWithName("power3")!.containsPoint(location)) {
                        return self.movethePowerUp = true
                    }
                }
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
            case states.beforeMission:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonPlay")!.containsPoint(location)) {
                        self.nextState = .mission
                        return
                    }
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .floors
                        return
                    }
                    if (self.childNodeWithName("skin1")!.containsPoint(location)) {
                        return
                    }
                    if (self.childNodeWithName("skin2")!.containsPoint(location)) {
                        return
                    }
                    if (self.childNodeWithName("skin3")!.containsPoint(location)) {
                        return
                    }
                    if (self.childNodeWithName("power1")!.containsPoint(location)) {
                        return
                    }
                    if (self.childNodeWithName("power2")!.containsPoint(location)) {
                        return
                    }
                    if (self.childNodeWithName("power3")!.containsPoint(location)) {
                        return
                    }
                }
                break
                
            default:
                break
            }
        }
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        
        self.childNodeWithName("skin1")?.removeFromParent()
        self.childNodeWithName("skin2")?.removeFromParent()
        self.childNodeWithName("skin3")?.removeFromParent()
        self.childNodeWithName("power1")?.removeFromParent()
        self.childNodeWithName("power2")?.removeFromParent()
        self.childNodeWithName("power3")?.removeFromParent()
        
        if(self.moveTheSkin){
            
            if(self.skinPageNumber == 5){
                self.skinPageNumber = self.skinPageNumber + 1
            }
            if(self.skinPageNumber < 5){
                self.skinPageNumber = self.skinPageNumber + 3
                
            }
            self.moveTheSkin = false
        }
        if(self.movethePowerUp){
            if(self.powerUpPageNumber == 5){
                self.powerUpPageNumber = self.powerUpPageNumber + 1
            }
            if(self.powerUpPageNumber < 5){
                self.powerUpPageNumber = self.powerUpPageNumber + 3
                
            }
            self.movethePowerUp = false
        }
        
        powerUpPaged(self.powerUpPageNumber)
        skinPaged(self.skinPageNumber)
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        
        self.childNodeWithName("skin1")?.removeFromParent()
        self.childNodeWithName("skin2")?.removeFromParent()
        self.childNodeWithName("skin3")?.removeFromParent()
        self.childNodeWithName("power1")?.removeFromParent()
        self.childNodeWithName("power2")?.removeFromParent()
        self.childNodeWithName("power3")?.removeFromParent()
        
        if(self.moveTheSkin){
            if(self.skinPageNumber == 0){
                self.skinPageNumber = self.skinPageNumber - 1
            }
            if(self.skinPageNumber > -1){
                self.skinPageNumber = self.skinPageNumber - 3
            }
            
            self.moveTheSkin = false
        }
        
        if(self.movethePowerUp){
            if(self.powerUpPageNumber == 0){
                self.powerUpPageNumber = self.powerUpPageNumber - 1
            }
            if(self.powerUpPageNumber > -1){
                self.powerUpPageNumber = self.powerUpPageNumber - 3
            }
            
            self.movethePowerUp = false
        }
        powerUpPaged(self.powerUpPageNumber)
        skinPaged(self.skinPageNumber)
    }
    
    // Controle de paginacao //******************************************************
    func skinPaged(j:Int){
        
        var currentPlayer = AppDelegate.memoryCard.playerData
        
        var dSkins:NSArray = currentPlayer.skins.allObjects
        
        var nSkins = Skins.types.count
        
        var buttonSkin1  = Skins.types[j+1].image
        
        var buttonSkin2  = Skins.types[j+2].image
        
        var buttonSkin3  = Skins.types[j+3].image
        
        
        self.addChild(Control(name: "skin1", textureName: buttonSkin1, x: 450, y: 120, xAlign:.left, yAlign:.center))
        
        self.addChild(Control(name: "skin2", textureName: buttonSkin2, x: 610, y: 120, xAlign:.left, yAlign:.center))
        
        self.addChild(Control(name: "skin3", textureName: buttonSkin3, x: 770, y: 120, xAlign:.left, yAlign:.center))
    }
    
    func powerUpPaged(j:Int){
        
        var currentPlayer = AppDelegate.memoryCard.playerData
        
        var dPowerUps:NSArray = currentPlayer.powerUps.allObjects
        
        var nPowerUps = PowerUps.types.count
        
        var buttonSkin1  = PowerUps.types[j+1].image
        
        var buttonSkin2  = PowerUps.types[j+2].image
        
        var buttonSkin3  = PowerUps.types[j+3].image
        
        
        self.addChild(Control(name: "power1", textureName: buttonSkin1 , x: 450, y: 230, xAlign:.left, yAlign:.center))
        
        self.addChild(Control(name: "power2", textureName: buttonSkin2 , x: 610, y: 230, xAlign:.left, yAlign:.center))
        
        self.addChild(Control(name: "power3", textureName: buttonSkin3 , x: 770, y: 230, xAlign:.left, yAlign:.center))
    }
    //
}
