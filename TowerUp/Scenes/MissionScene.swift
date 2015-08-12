//
//  MissionScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MissionScene: GameScene {
    enum states {
        case mission
        case afterMission
    }
    
    var state = states.mission
    var nextState = states.mission
    
    var xPos = 500
    var yPos = 200
    
    let velo:CGFloat = 3
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.backgroundColor = GameColors.cornflowerBlue
        //self.addChild(Control(name: "missionBackground", x:0, y:0, align:.center))
        
        self.addChild(Label(name: "labelTitle", textureName: "MissionScene", x: 667, y: 130, align:.center))
    
        //test
        
        self.addChild(Player(name: "player", textureName: "buttonYellowPressed", x: xPos , y: yPos , align:.center))
    
        self.addChild(Button(name: "buttonBack", textureName: "buttonGrayLeft" ,x:81, y:633, xAlign:.left, yAlign:.down))
        
        self.addChild(Button(name: "buttonRight", textureName: "buttonGrayLeft" ,x:161, y:633, xAlign:.left, yAlign:.down))
        
        self.addChild(Button(name: "buttonLeft", textureName: "buttonGrayLeft" ,x:241, y:633, xAlign:.left, yAlign:.down))
        
        self.addChild(Button(name: "buttonJump" ,x:1236, y:652, xAlign:.right, yAlign:.down))
        
       
        
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
                let player = self.childNodeWithName("//player")! as! Player
                player.update(currentTime)
                break
            case states.afterMission:
                self.view!.presentScene(AfterMissionScene(), transition: Config.defaultGoTransition)
                break
                
            default:
                break
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        Control.touchesBegan(self, touches: touches as! Set<UITouch>)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        Control.touchesMoved(self)
    }

    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    Control.touchesEnded(self, touches: touches as! Set<UITouch>)
    for touch in (touches as! Set<UITouch>) {
    let location = touch.locationInNode(self)
    
    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
    self.view?.presentScene(AfterMissionScene(), transition: SKTransition.crossFadeWithDuration(1))
    return
    }
        }
    }
    
        
}
