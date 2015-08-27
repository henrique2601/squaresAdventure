//
//  PowerUpScene.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 20/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit
import CoreData

class PowerUpScene: GameScene {
    
    enum states {
        case powerUp
        case mission
        case floors
    }
    
    var state = states.powerUp
    var nextState = states.powerUp
    
    var powerUpPageNumber = -1
    var skinPageNumber = -1
    var moveTheSkin = false
    var movethePowerUp = false
    
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        
        self.backgroundColor = GameColors.blue
        
        self.addChild(Control(name: "beforeMissionBackground", x:0, y:0, align:.center))
        
        self.addChild(Button(name: "buttonPlay", textureName: "buttonYellow", text:"GO!", x: 1000, y: 580, align:.center))
        self.addChild(Button(name: "buttonBack", textureName: "buttonGrayLeft", x: 20, y: 652, xAlign:.left, yAlign:.down))
        
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
    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState){
            switch (self.state) {
                
            case .powerUp:
                break
                
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
    
    // Controle para saber se moveu skins ou powerUps // ***************************
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if (self.childNodeWithName("skin1")!.containsPoint(location)) {
                println("Touched and recognize the skin")
                return self.moveTheSkin = true
            }
            if (self.childNodeWithName("skin2")!.containsPoint(location)) {
                println("Touched and recognize the skin")
                return self.moveTheSkin = true
            }
            if (self.childNodeWithName("skin3")!.containsPoint(location)) {
                println("Touched and recognize the skin")
                return self.moveTheSkin = true
            }
            
            if (self.childNodeWithName("power1")!.containsPoint(location)) {
                println("Touched and recognize the power")
                return self.movethePowerUp = true
                
            }
            if (self.childNodeWithName("power2")!.containsPoint(location)) {
                println("Touched and recognize the power")
                return self.movethePowerUp = true
                
            }
            
            if (self.childNodeWithName("power3")!.containsPoint(location)) {
                println("Touched and recognize the power")
                return self.movethePowerUp = true
                
            }
            
            
        }
        
    }
    
    // Controle para saber e apertou alguma skin ou powerUp ou button play ou button back //
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.powerUp:
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
    
    
    
    // Controle de paginacao //******************************************************
    
    
    func skinPaged(j:Int){
        
        
        var currentPlayer = AppDelegate.memoryCard.playerData
        
        var dSkins:NSArray = currentPlayer.skins.allObjects
        
        var nSkins = Skins.types.count
        
        println(nSkins)
        
        var buttonSkin1  = Skins.types.objectAtIndex(j+1).image
        
        var buttonSkin2  = Skins.types.objectAtIndex(j+2).image
        
        var buttonSkin3  = Skins.types.objectAtIndex(j+3).image
        
        
        self.addChild(Control(name: "skin1", textureName: buttonSkin1, x: 450, y: 120, xAlign:.left, yAlign:.center))
        
        self.addChild(Control(name: "skin2", textureName: buttonSkin2, x: 610, y: 120, xAlign:.left, yAlign:.center))
        
        self.addChild(Control(name: "skin3", textureName: buttonSkin3, x: 770, y: 120, xAlign:.left, yAlign:.center))
        
        
    }
    
    
    func powerUpPaged(j:Int){
        
        
        var currentPlayer = AppDelegate.memoryCard.playerData
        
        var dPowerUps:NSArray = currentPlayer.powerUps.allObjects
        
        var nPowerUps = PowerUps.types.count
        
        println(nPowerUps)
        
        var buttonSkin1  = PowerUps.types.objectAtIndex(j+1).image
        
        var buttonSkin2  = PowerUps.types.objectAtIndex(j+2).image
        
        var buttonSkin3  = PowerUps.types.objectAtIndex(j+3).image
        
        
        self.addChild(Control(name: "power1", textureName: buttonSkin1 , x: 450, y: 230, xAlign:.left, yAlign:.center))
        
        self.addChild(Control(name: "power2", textureName: buttonSkin2 , x: 610, y: 230, xAlign:.left, yAlign:.center))
        
        self.addChild(Control(name: "power3", textureName: buttonSkin3 , x: 770, y: 230, xAlign:.left, yAlign:.center))
        
        
    }
    
    
}

// Power Ups e Skins Organizacao de dados// **************************************

class PowerUpType: NSObject {
    
    var image:String
    
    init(image:String) {
        self.image = image
    }
}

class PowerUps :NSObject {
    
    static var types:NSArray = NSArray(array: [
        PowerUpType(image:"bubble"), //0
        PowerUpType(image:"bubbleUp"), //1
        PowerUpType(image:"bunny"), //2
        PowerUpType(image:"carrotGold"), //3
        PowerUpType(image:"carrotNormal"), //4
        PowerUpType(image:"doubleLife"), //5
        PowerUpType(image:"empty"), //6
        PowerUpType(image:"gold"), //7
        PowerUpType(image:"jetPack"), //8
        PowerUpType(image:"player"), //9
        PowerUpType(image:"portalOranje"), //10
        PowerUpType(image:"wings"), //11
        PowerUpType(image:"bubbleUp")  //12
        ])
    
    
    
    
}

class SkinsType: NSObject {
    
    var image:String
    
    init(image:String) {
        self.image = image
    }
}

class Skins :NSObject {
    
    static var types:NSArray = NSArray(array: [
        SkinsType(image:"elephant"), //0
        SkinsType(image:"giraffe"), //1
        SkinsType(image:"hippo"), //2
        SkinsType(image:"monkey"), //3
        SkinsType(image:"panda"), //4
        SkinsType(image:"parrot"), //5
        SkinsType(image:"penguin"), //6
        SkinsType(image:"pig"), //7
        SkinsType(image:"rabbit"), //8
        SkinsType(image:"snake"), //9
        
        ])
}