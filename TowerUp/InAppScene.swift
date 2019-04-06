//
//  CreditsScene.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 11/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit


class InAppScene: GameScene {
    enum states {
        case inApp
        case mainMenu
        
    }
    
    var state = states.inApp
    var nextState = states.inApp
    
    var productsScrollNode:ScrollNode!
    var productsArray = Array<SKSpriteNode>()
    var productsIndex = 0
    
    
    var buttonBack:Button!
    var buttonAd:Button!
    
    override func didMove(to view: SKView) {
       
        super.didMove(to: view)
        
        
        IAPHelper.sharedInstance.requestProducts()
        
        self.addChild(Control(textureName: "inAppBackGround", xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        
        //Products
       
        
        for productsIndex in 0 ..< 6 {
            let cell = SKSpriteNode(imageNamed: "boxSmall")
            
            let spriteNode = SKSpriteNode(imageNamed: "boxSmallLocked")
            spriteNode.zPosition = cell.zPosition + 1
            cell.addChild(spriteNode)
            
            let labelName = Label(text: "Locked")
            cell.addChild(labelName)
            
            productsArray.append(cell)
        }
        
        self.productsScrollNode = ScrollNode(x: 667, y: 466, cells:productsArray, spacing: 1, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes:true, scaleDistance:1334/4 + 100, index: 1)
        self.addChild(self.productsScrollNode)
        
        
    }
    
    override func update(currentTime: TimeInterval) {
        super.update(currentTime: currentTime)
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.inApp:
                for touch in (touches ) {
                    let location = touch.location(in: self)
                    
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
