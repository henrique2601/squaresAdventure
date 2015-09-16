//
//  LobbyScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/7/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class LobbyScene: GameScene, UITextFieldDelegate {
    enum states {
        case lobby
        case multiplayerMission
        case localLobby
        case mainMenu
    }
    
    var room: Int = 0
    var state = states.lobby
    var nextState = states.lobby
    let socket = SocketIOClient(socketURL: "179.232.86.110:3001", options: nil)

    var myTextField: Textfield!
    var playerData = MemoryCard.sharedInstance.playerData
    
    
    
    
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(name: "lobby1Background", x:0, y:0, align:.center))
        self.backgroundColor = GameColors.blue
        
        
        
        
        
        
        self.addChild(Button(name: "buttonOnline", textureName: "buttonYellow", text:"ONLINE GAME", x: 229, y: 269, align:.center))
        self.addChild(Button(name: "buttonQuick", textureName: "buttonYellow", text:"QUICKPLAY", x: 229, y: 393, align:.center))
        self.addChild(Button(name: "buttonLocal", textureName: "buttonYellow", text:"LOCAL GAME", x: 229, y: 517, align:.center))
        
        self.myTextField = Textfield(name: self.playerData.name , x: 741, y: 240, align:.center, view:self.view!)
        self.myTextField.myTextField.delegate = self
        self.addChild(self.myTextField)
        
        
        

        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down))
        
        
        

        
    }
    
    // Called by tapping return on the keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    //do anything befor keyboard go away
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        self.playerData.name = textField.text
        return true
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
                nextScene.localName = self.myTextField.myTextField.text
                self.view!.presentScene(nextScene, transition: Config.defaultGoTransition)
                break
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultBackTransition)
                break
                
            case states.localLobby:
                self.view!.presentScene(LocalLobbyScene(), transition: Config.defaultBackTransition)
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
                    
                    if (self.childNodeWithName("buttonOnline")!.containsPoint(location)) {
                        room = 0
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonQuick")!.containsPoint(location)) {
                        room = 1
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonLocal")!.containsPoint(location)) {
                        room = 2
                        self.nextState = .localLobby
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
