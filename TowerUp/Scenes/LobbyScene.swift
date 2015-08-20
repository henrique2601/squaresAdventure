//
//  LobbyScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/7/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class LobbyScene: GameScene {
    enum states {
        case lobby
        case multiplayerMission
        case mainMenu
    }
    
    var room: Int = 0
    var state = states.lobby
    var nextState = states.lobby
    let socket = SocketIOClient(socketURL: "179.232.86.110:3001", options: nil)
    var localName: String? = ""
    
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(name: "beforeMissionBackground", x:0, y:0, align:.center))
        
        self.addChild(Label(name: "labelTitle", textureName: "BeforeMissionScene", x: 667, y: 130, align:.center))
        
        self.addChild(Button(name: "buttonRoom0", textureName: "buttonYellow", text:"room0", x: 550, y: 189, align:.center))
        
        
        self.addChild(Button(name: "buttonRoom1", textureName: "buttonYellow", text:"room1", x: 550, y: 287, align:.center)) // y = 98
        self.addChild(Button(name: "buttonRoom2", textureName: "buttonYellow", text:"room2", x: 550, y: 385, align:.center))
        self.addChild(Button(name: "buttonRoom3", textureName: "buttonYellow", text:"room3", x: 550, y: 483, align:.center))
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGrayLeft", x: 20, y: 652, xAlign:.left, yAlign:.down))
        self.localName = self.randomStringWithLength(8) as String
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
                
            case states.multiplayerMission:
                var nextScene  = MultiplayerGameScene()
                nextScene.room = self.room
                nextScene.localName = self.localName
                self.view!.presentScene(nextScene, transition: Config.defaultGoTransition)
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
            case states.lobby:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonRoom0")!.containsPoint(location)) {
                        room = 0
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonRoom1")!.containsPoint(location)) {
                        room = 1
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonRoom2")!.containsPoint(location)) {
                        room = 2
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonRoom3")!.containsPoint(location)) {
                        room = 3
                        self.nextState = .multiplayerMission
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
