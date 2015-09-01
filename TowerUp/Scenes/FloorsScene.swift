//
//  FloorsScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class FloorsScene: GameScene {
    enum states {
        case floors
        case beforeMission
        case towers
    }
    
    var state = states.floors
    var nextState = states.floors
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        self.addChild(Control(name: "floorsBackground", x:0, y:0, align:.center))
        
        self.addChild(Label(name: "labelTitle", textureName: "FloorsScene", x: 667, y: 130, align:.center))
        
        self.addChild(Button(name: "buttonA", textureName: "buttonYellow", text:"FLOOR 0", x: 550, y: 189, align:.center))
        
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
                
            case states.beforeMission:
                self.view!.presentScene(MissionScene(), transition: Config.defaultGoTransition)
                break
                
            case states.towers:
                self.view!.presentScene(TowersScene(), transition: Config.defaultBackTransition)
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
            case states.floors:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonA")!.containsPoint(location)) {
                        self.nextState = .beforeMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .towers
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
